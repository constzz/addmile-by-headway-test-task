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
    var currentChapter: Chapter? { get }
    var currentDurationInSeconds: Double { get }
    func togglePlayPause()
    func reverse()
    func forward()
//    func previous()
//    func next()
}

struct Chapter: Hashable {
    let index: Int
    let title: String
}

final class AudioViewModel: AudioViewModelProtocol {
    private(set) var currentDurationInSeconds: Double
    private(set) var isPlaying: Bool = false
    private(set) var currentChapter: Chapter?
    private let chapters: [Chapter]
    
    private enum Constants {
        static let reverseDurationAmountInSeconds = 5.0
        static let forwardDurationAmountInSeconds = 1.0
    }
    
    init(currentDurationInSeconds: Double? = nil, chapters: [Chapter]) {
        self.currentDurationInSeconds = currentDurationInSeconds ?? 0.0
        self.chapters = chapters
        self.currentChapter = chapters.first
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
    func forward() {
        self.currentDurationInSeconds += Constants.reverseDurationAmountInSeconds
    }
    
    func reverse() {
        self.currentDurationInSeconds -= Constants.reverseDurationAmountInSeconds
    }
}

final class ListenScreenViewModelTests: XCTestCase {
    func test_togglePlayPauseOnce_SetsIsPlayingToTrue() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 1)
        XCTAssertTrue(sut.isPlaying)
    }
    
    func test_togglePlayPauseTwice_SetsIsPlayingToFalse() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 2)
        XCTAssertFalse(sut.isPlaying)
    }
    
    func test_togglePlayPauseTriple_SetsIsPlayingToTrue() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 3)
        XCTAssertTrue(sut.isPlaying)
    }
    
    func test_initialDurationIsZeroByDefault() {
        let sut = makeSUT()
        XCTAssertEqual(sut.currentDurationInSeconds, 0.0)
    }
    
    func test_reverse_reversesDuration5SecondsBack() {
        let sut = makeSUT(currentDurationInSeconds: 20.0)
        sut.reverse()
        XCTAssertEqual(sut.currentDurationInSeconds, 15.0)
    }
    
    func test_forward_forwardsDuration5SecondsBack() {
        let sut = makeSUT(currentDurationInSeconds: 11.0)
        sut.forward()
        XCTAssertEqual(sut.currentDurationInSeconds, 16.0)
    }
    
    func test_initialChapterIsFirstFromTheList() {
        let chapters = createRandomChapters()
        let sut = makeSUT(chapters: chapters)
        
        XCTAssertEqual(sut.currentChapter, chapters.first)
    }
    
    func test_initialChapterIsNil_ifListIsEmpty() {
        let sut = makeSUT(chapters: [])
        
        XCTAssertEqual(sut.currentChapter, nil)
    }
    
    private func makeSUT(
        currentDurationInSeconds: Double? = nil,
        chapters: [Chapter]? = nil
    ) -> AudioViewModelProtocol {
        return AudioViewModel(
            currentDurationInSeconds: currentDurationInSeconds,
            chapters: chapters ?? createRandomChapters()
        )
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

private func createRandomChapters() -> [Chapter] {
    ["Lorem 1", "Ipsum here 2", "No bumu 3", "Smth 4"].enumerated().map { index, title in
        return .init(index: index, title: title)
    }
}
