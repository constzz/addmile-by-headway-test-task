//
//  ListenScreenUIIntegrationTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
import SwiftUI
import UIKit
import ViewInspector
import Combine
@testable import BookListener

final class ListenScreenUIIntegrationTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_listenScreen_isPlayingAudioByDefault() async {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        
        XCTAssertTrue(audioViewModel.isPlaying)
    }
    
    func test_listenScreen_pausesOnPlayPauseClick() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        try view.hitButtonWith(role: .pause)
        
        XCTAssertFalse(audioViewModel.isPlaying)
    }
    
    func test_listenScreen_resumesOnTwicePlayPauseClick() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        try view.hitButtonWith(role: .pause)
        try view.hitButtonWith(role: .play)
        
        XCTAssertTrue(audioViewModel.isPlaying)
    }
    
    func test_listenScreen_pausesOnTriplePlayPauseClick() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        try view.hitButtonWith(role: .pause)
        try view.hitButtonWith(role: .play)
        try view.hitButtonWith(role: .pause)
        
        XCTAssertFalse(audioViewModel.isPlaying)
    }
    
    func test_listenScreen_reverseAudio() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        
        audioViewModel.seekTo(15.0)
        try view.hitButtonWith(role: .reverse)
        
        audioViewModel.currentTimeInSeconds.waitForPublisher(
            expectedValue: 10.0,
            accuracy: 0.9,
            cancellables: &cancellables)
    }
    
    func test_listenScreen_forwardAudio() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        
        audioViewModel.seekTo(15.0)
        try view.hitButtonWith(role: .forward)
        
        audioViewModel.currentTimeInSeconds.waitForPublisher(
            expectedValue: 25.0,
            accuracy: 0.9,
            cancellables: &cancellables)
    }
    
    func test_listScreen_showsCurrentProgress() async throws {
        let (view, audioViewModel) = makeSUT()
        
        let totalDuration = audioViewModel.totalDurationInSeconds
        let halfOfAudioInSeconds = totalDuration / 2
        audioViewModel.seekTo(halfOfAudioInSeconds)
        
        let slider = try view.inspect().find(SliderView.self)
        let sliderActual = try slider.actualView()
        
        await view.forceRender()
                
        sliderActual.leftLabelValuePublisher.waitForPublisher(
            expectedValue: "00:27",
            cancellables: &cancellables)
        sliderActual.valuePublisher.waitForPublisher(
            expectedValue: 50,
            cancellables: &cancellables)
        sliderActual.rightLabelValuePublisher.waitForPublisher(
            expectedValue: "00:54",
            cancellables: &cancellables)

    }
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        view: some View,
        audioViewModel: AudioViewModelProtocol
    ) {
        let audioViewModel = AudioViewModel(book: .init())
        let listenScreenViewModel = ListenScreenViewModel(
            chapters: createRandomChapters(),
            defaultChapterIndex: 0,
            audioViewModel: audioViewModel)
        let view = ListenScreenView(mode: .listen, isAnimating: false, viewModel: listenScreenViewModel)
        return (view, audioViewModel)
    }
}

extension AnyPublisher where Failure == Never, Output: Equatable {
    func waitForPublisher(
        expectedValue: Output,
        cancellables: inout Set<AnyCancellable>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        self.first().sink(receiveValue: { isPlaying in
            XCTAssertEqual(isPlaying, expectedValue, file: file, line: line)
        }).store(in: &cancellables)
    }
}

extension AnyPublisher where Failure == Never, Output == Double {
    func waitForPublisher(
        expectedValue: Output,
        accuracy: Double,
        cancellables: inout Set<AnyCancellable>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        self.first().sink(receiveValue: { isPlaying in
            XCTAssertEqual(isPlaying, expectedValue, accuracy: accuracy, file: file, line: line)
        }).store(in: &cancellables)
    }
}

extension View {
    func hitButtonWith(
        role: PlaybackControlView.Role,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let playbackControlView = try self.inspect().find(PlaybackControlView.self).actualView()
        switch role {
        case .previous:
            return try playbackControlView.inspect().hStack()[0].button().tap()
        case .reverse:
            return try playbackControlView.inspect().hStack()[1].button().tap()
        case .play, .pause:
            return try playbackControlView.inspect().hStack()[2].button().tap()
        case .forward:
            return try playbackControlView.inspect().hStack()[3].button().tap()
        case .next:
            return try playbackControlView.inspect().hStack()[4].button().tap()
        }
    }
}

extension View {
    func forceRender() async {
        await UIHostingController(rootView: self).forceRender()
    }
    
    func putInUIHostingController() -> UIHostingController<Self> {
        UIHostingController(rootView: self)
    }
}

extension UIHostingController {
    func forceRender() {
        _render(seconds: 0)
    }
}
