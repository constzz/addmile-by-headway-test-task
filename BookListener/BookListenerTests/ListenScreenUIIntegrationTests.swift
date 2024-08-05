//
//  ListenScreenUIIntegrationTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

@testable import BookListener
import Combine
import SwiftUI
import UIKit
import ViewInspector
import XCTest

// MARK: - ListenScreenUIIntegrationTests

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
            cancellables: &cancellables
        )
    }

    func test_listenScreen_forwardAudio() async throws {
        let (view, audioViewModel) = makeSUT()
        await view.forceRender()

        audioViewModel.seekTo(15.0)
        try view.hitButtonWith(role: .forward)

        audioViewModel.currentTimeInSeconds.waitForPublisher(
            expectedValue: 25.0,
            accuracy: 0.9,
            cancellables: &cancellables
        )
    }

    func test_listenScreen_nextPreviousAudio() async throws {
        let (view, audioViewModel, listenVM) = makeSUT()
        await view.forceRender()

        try view.hitButtonWith(role: .next)
        XCTAssertEqual(listenVM.currentChapter?.index, 1)

        try view.hitButtonWith(role: .next)
        XCTAssertEqual(listenVM.currentChapter?.index, 2)

        try view.hitButtonWith(role: .previous)
        XCTAssertEqual(listenVM.currentChapter?.index, 1)
    }

    func test_listenScreen_nextPreviousAudio_blocksButtons() async throws {
        let (view, audioViewModel, listenVM) = makeSUT()
        await view.forceRender()

        listenVM.isPreviousActivePublisher.waitForPublisher(expectedValue: false, cancellables: &cancellables)
        listenVM.isNextActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)

        try view.hitButtonWith(role: .next)

        listenVM.isPreviousActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)
        listenVM.isNextActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)

        try view.hitButtonWith(role: .next)
        listenVM.isPreviousActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)
        listenVM.isNextActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)

        try view.hitButtonWith(role: .next)
        try view.hitButtonWith(role: .next)
        try view.hitButtonWith(role: .next)

        listenVM.isPreviousActivePublisher.waitForPublisher(expectedValue: true, cancellables: &cancellables)
        listenVM.isNextActivePublisher.waitForPublisher(expectedValue: false, cancellables: &cancellables)
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
            cancellables: &cancellables
        )
        sliderActual.valuePublisher.waitForPublisher(
            expectedValue: 50,
            cancellables: &cancellables
        )
        sliderActual.rightLabelValuePublisher.waitForPublisher(
            expectedValue: "00:54",
            cancellables: &cancellables
        )
    }

    func test_opensNewChapterOnFinish() async {
        let (_, audioViewModel, listenScreenVM) = makeSUT()

        XCTAssertEqual(listenScreenVM.currentChapter?.index, 0)

        audioViewModel.onFinishPlaying?()

        XCTAssertEqual(listenScreenVM.currentChapter?.index, 1)
    }

    func test_changesSpeeds() async throws {
        let (view, audioViewModel, listenScreenVM) = makeSUT()

        await view.forceRender()

        let speedChangeView = try view.inspect().find(SpeedChangeView.self).actualView()

        let speedsToTestOrdered: [Float] = [1.0, 1.25, 1.5, 1.75, 2.0, 0.25, 0.50, 0.75, 1.0]

        try speedsToTestOrdered.forEach { speed in
            speedChangeView.speedValueFormattedPublisher.waitForPublisher(expectedValue: speed.description, cancellables: &cancellables)
            XCTAssertEqual(audioViewModel.speed.description, speed.description)
            try speedChangeView.inspect().button().tap()
        }
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        view: some View,
        audioViewModel: AudioViewModelProtocol
    ) {
        let (view, audioViewModel, _) = makeSUT(file: file, line: line)
        return (view, audioViewModel)
    }

    private func makeSUT(
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) -> (
        view: some View,
        audioViewModel: AudioViewModelProtocol,
        listenScreenViewModel: ListenScreenViewModel
    ) {
        let audioViewModel = AudioViewModel()
        try! audioViewModel.set(url: Mock.thinkAndGrowRich0File!)
        let listenScreenViewModel = ListenScreenViewModel(
            book: Mock.mockedThinkAndGrowRichBook,
            defaultChapterIndex: 0,
            audioViewModel: audioViewModel,
            mode: .listen
        )
        let view = ListenScreenView(
            isAnimating: false,
            viewModel: listenScreenViewModel
        )
        return (view, audioViewModel, listenScreenViewModel)
    }
}

extension AnyPublisher where Failure == Never, Output: Equatable {
    func waitForPublisher(
        expectedValue: Output,
        cancellables: inout Set<AnyCancellable>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        first().sink(receiveValue: { isPlaying in
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
        first().sink(receiveValue: { isPlaying in
            XCTAssertEqual(isPlaying, expectedValue, accuracy: accuracy, file: file, line: line)
        }).store(in: &cancellables)
    }
}

extension View {
    func hitButtonWith(
        role: PlaybackControlView.Role,
        file _: StaticString = #filePath,
        line _: UInt = #line
    ) throws {
        let playbackControlView = try inspect().find(PlaybackControlView.self).actualView()
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
