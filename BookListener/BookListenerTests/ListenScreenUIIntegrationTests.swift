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
@testable import BookListener

final class ListenScreenUIIntegrationTests: XCTestCase {
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
        
        XCTAssertEqual(audioViewModel.currentTimeInSeconds, 10.0, accuracy: 0.09)
    }
    
    func test_listenScreen_forwardAudio() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()
        
        audioViewModel.seekTo(15.0)
        try view.hitButtonWith(role: .forward)
        
        XCTAssertEqual(audioViewModel.currentTimeInSeconds, 25.0, accuracy: 0.09)
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
