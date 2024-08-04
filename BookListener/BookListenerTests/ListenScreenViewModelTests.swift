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
    func previous()
    func next()
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
    
    init(
        currentDurationInSeconds: Double? = nil,
        chapters: [Chapter],
        defaultChapterIndex: Int?
    ) {
        self.currentDurationInSeconds = currentDurationInSeconds ?? 0.0
        self.chapters = chapters
        if let defaultChapterIndex, let firstChapter = chapters.safelyRetrieve(elementAt: defaultChapterIndex) {
            self.currentChapter = firstChapter
        } else {
            self.currentChapter = chapters.first
        }
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
    
    func previous() {
        guard let currentChapter else { return }
        if let previousChapter = chapters.safelyRetrieve(elementAt: currentChapter.index - 1) {
            self.currentChapter = previousChapter
        }
    }
    
    func next() {
        guard let currentChapter else { return }
        if let nextChapter = chapters.safelyRetrieve(elementAt: currentChapter.index + 1) {
            self.currentChapter = nextChapter
        }
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
        
    func test_previousSetsPreviousChapter() {
        let chapters = createRandomChapters()
        let currentIndex = 2
        let expectedChapterToOpen = chapters.safelyRetrieve(elementAt: 1)

        assertCurrentChapterOfAudioViewModel(
            is: expectedChapterToOpen,
            ifCurrentIndexIs: currentIndex,
            chatpers: chapters,
            afterAction: { sut in sut.previous() }
        )
    }
    
    func test_previousRemainsSameChapter_ifCurrentIsFirst() {
        let chapters = createRandomChapters()
        let currentIndex = 0
        let expectedChapterToOpen = chapters.first

        assertCurrentChapterOfAudioViewModel(
            is: expectedChapterToOpen,
            ifCurrentIndexIs: currentIndex,
            chatpers: chapters,
            afterAction: { sut in sut.previous() }
        )
    }
    
    func test_nextSetsNextChapter() {
        let chapters = createRandomChapters()
        let currentIndex = 2
        let expectedChapterToOpen = chapters.safelyRetrieve(elementAt: 3)

        assertCurrentChapterOfAudioViewModel(
            is: expectedChapterToOpen,
            ifCurrentIndexIs: currentIndex,
            chatpers: chapters,
            afterAction: { sut in sut.next() }
        )
    }
    
    func test_nextRemainsSameChapter_ifCurrentIsLast() {
        let chapters = createRandomChapters()
        let currentIndex = chapters.count - 1
        let expectedChapterToOpen = chapters.last

        assertCurrentChapterOfAudioViewModel(
            is: expectedChapterToOpen,
            ifCurrentIndexIs: currentIndex,
            chatpers: chapters,
            afterAction: { sut in sut.next() }
        )
    }
    
    func test_currentChapterIsFirst_ifCurrentIndexisNotIndexOfArray() {
        let chapters = createRandomChapters()
        let currentIndex = 999
        let expectedChapterToOpen = chapters.first

        assertCurrentChapterOfAudioViewModel(
            is: expectedChapterToOpen,
            ifCurrentIndexIs: currentIndex,
            chatpers: chapters,
            afterAction: { _ in }
        )
    }
    
    private func assertCurrentChapterOfAudioViewModel(
        is expectedChapterToOpen: Chapter?,
        ifCurrentIndexIs index: Int,
        chatpers: [Chapter]?,
        afterAction action: (AudioViewModelProtocol) -> Void,
        file filePath: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNotNil(expectedChapterToOpen, file: filePath, line: line)
        
        let sut = makeSUT(chapters: chatpers, defaultChapterIndex: index)
        action(sut)
        XCTAssertEqual(sut.currentChapter, expectedChapterToOpen, file: filePath, line: line)
    }

    
    private func makeSUT(
        currentDurationInSeconds: Double? = nil,
        chapters: [Chapter]? = nil,
        defaultChapterIndex: Int? = nil
    ) -> AudioViewModelProtocol {
        return AudioViewModel(
            currentDurationInSeconds: currentDurationInSeconds,
            chapters: chapters ?? createRandomChapters(),
            defaultChapterIndex: defaultChapterIndex
        )
    }

}

extension Array {
    func safelyRetrieve(elementAt index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
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
