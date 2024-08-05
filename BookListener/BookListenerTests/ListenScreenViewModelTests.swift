//
//  ListenScreenViewModelTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
import Combine
@testable import BookListener

final class ListenScreenViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
        
    func test_togglePlayPauseOnce_SetsIsPlayingToTrue() async throws {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 1)
        
        waitForIsPlayingPublishing(sut: sut, expectedValue: true)
    }
    
    func test_togglePlayPauseTwice_SetsIsPlayingToFalse() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 2)
        waitForIsPlayingPublishing(sut: sut, expectedValue: false)
    }
    
    func test_togglePlayPauseTriple_SetsIsPlayingToTrue() {
        let sut = makeSUT()
        sut.togglePlayPause(amountOfTimes: 3)
        waitForIsPlayingPublishing(sut: sut, expectedValue: true)
    }
    
    func test_initialDurationIsZeroByDefault() {
        let sut = makeSUT()
        sut.currentTimeInSeconds.waitForPublisher(expectedValue: 0.0, cancellables: &cancellables)
    }
    
    func test_reverse_reversesDuration5SecondsBack() {
        let sut = makeSUT()
        sut.seekTo(20.0)
        
        sut.reverse()
        
        sut.currentTimeInSeconds.waitForPublisher(expectedValue: 15.0, cancellables: &cancellables)
    }
    
    func test_forward_forwardsDuration5SecondsBack() {
        let sut = makeSUT()
        sut.seekTo(11.0)
        
        sut.forward()
        
        sut.currentTimeInSeconds.waitForPublisher(expectedValue: 21.0, cancellables: &cancellables)
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
        afterAction action: (ListenScreenViewModelProtocol) -> Void,
        file filePath: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNotNil(expectedChapterToOpen, file: filePath, line: line)
        
        let sut = makeSUT(chapters: chatpers, defaultChapterIndex: index)
        action(sut)
        XCTAssertEqual(sut.currentChapter, expectedChapterToOpen, file: filePath, line: line)
    }

    
    private func makeSUT(
        chapters: [Chapter]? = nil,
        defaultChapterIndex: Int? = nil
    ) -> ListenScreenViewModelProtocol {
        let audioViewModel = AudioViewModel()
        try! audioViewModel.set(url: createRandomChapters().first!.url!)
        return ListenScreenViewModel(
            book: chapters == nil ? Mock.mockedThinkAndGrowRichBook : Book(chapters: chapters ?? [], coverURL: nil),
            defaultChapterIndex: defaultChapterIndex,
            audioViewModel: audioViewModel
        )
    }
    
    private func waitForIsPlayingPublishing(
        sut: ListenScreenViewModelProtocol,
        expectedValue: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        sut.isPlaying.first().sink(receiveValue: { isPlaying in
            XCTAssertEqual(isPlaying, expectedValue, file: file, line: line)
        }).store(in: &cancellables)
    }

}

// MARK: Test helpers
extension ListenScreenViewModelProtocol {
    func togglePlayPause(amountOfTimes: Int) {
        for _ in 1...amountOfTimes {
            togglePlayPause()
        }
    }
}

func createRandomChapters() -> [Chapter] {
    Mock.mockedThinkAndGrowRichBook.chapters
}
