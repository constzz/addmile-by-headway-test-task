//
//  AudioViewModelTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
@testable import BookListener

final class AudioViewModelAVFoundationIntegrationTests: XCTestCase {
    
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
        
        XCTAssertEqual(sut.currentTimeInSeconds, 0.0)
    }
    
    private func makeSUT(
    ) -> AudioViewModel {
        return AudioViewModel(book: .init())
    }

}
