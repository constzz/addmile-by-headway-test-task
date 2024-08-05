//
//  AudioViewModelAVFoundationIntegrationTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

@testable import BookListener
import Combine
import XCTest

final class AudioViewModelAVFoundationIntegrationTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func test_playStartsPlayingAudioPlayer() async throws {
        let sut = makeSUT()

        sut.play()
        XCTAssertTrue(sut.player.isPlaying)
    }

    func test_playPausesPlayingAudioPlayerAfterPlay() {
        let sut = makeSUT()

        sut.play()
        sut.pause()
        XCTAssertFalse(sut.player.isPlaying)
    }

    func test_notPlaysByDefault() {
        let sut = makeSUT()

        XCTAssertFalse(sut.player.isPlaying)
    }

    func test_currentTimeByDefaultIsZero() {
        let sut = makeSUT()

        sut.currentTimeInSeconds.waitForPublisher(expectedValue: 0.0, cancellables: &cancellables)
    }

    func test_seekToChangesCurrentTime() {
        let sut = makeSUT()

        sut.seekTo(3.0)

        sut.currentTimeInSeconds.waitForPublisher(expectedValue: 3.0, cancellables: &cancellables)
    }

    func test_defaultSpeedIsOne() {
        let sut = makeSUT()

        XCTAssertEqual(1.0, sut.speed)
    }

    func test_changesSpeed() {
        let speeds: [Float] = [0.25, 0.50, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
        let sut = makeSUT()

        speeds.forEach { speed in
            sut.changePlaybackSpeed(speed)
            XCTAssertEqual(sut.speed, speed)
        }
    }

    private func makeSUT(
    ) -> AudioViewModel {
        let sut = AudioViewModel()
        try! sut.set(url: Mock.thinkAndGrowRich0File!)
        return sut
    }
}
