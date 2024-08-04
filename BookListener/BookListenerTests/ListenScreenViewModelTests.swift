//
//  ListenScreenViewModelTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
import SwiftUI
@testable import BookListener

protocol AudioViewModelProtocol {
    var isPlaying: Bool { get }
    var durationInSeconds: Double { get }
    func togglePlayPause()
//    func reverse()
//    func forward()
//    func previous()
//    func next()
}

final class AudioViewModel: AudioViewModelProtocol {
    var durationInSeconds: Double = 0.0
    var isPlaying: Bool = false
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
}

final class ListenScreenViewModelTests: XCTestCase {
    func test_togglePlayPauseOnceSetsIsPlayingToTrue() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 1)
        XCTAssertTrue(sut.isPlaying)
    }
    
    func test_togglePlayPauseTwiceSetsIsPlayingToFalse() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 2)
        XCTAssertFalse(sut.isPlaying)
    }
    
    func test_togglePlayPauseTripleSetsIsPlayingToTrue() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 3)
        XCTAssertTrue(sut.isPlaying)
    }
    
    func test_initialDurationIsZero() {
        let sut = makeSUT()
        XCTAssertEqual(sut.durationInSeconds, 0.0)
    }
    
    private func makeSUT() -> AudioViewModelProtocol {
        return AudioViewModel()
    }

}

// MARK: Test helpers
extension AudioViewModelProtocol {
    func togglePlayPause(amountOfTimes: Int) {
        for i in 1...amountOfTimes {
            togglePlayPause()
        }
    }
}
