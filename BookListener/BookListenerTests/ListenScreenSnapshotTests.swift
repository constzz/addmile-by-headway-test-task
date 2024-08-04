//
//  ListenScreenSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
import Combine
@testable import BookListener

final class ListenScreenSnapshotTests: XCTestCase {
    func test_listenMode_empty() {
        let sut = makeSUT(mode: .listen)
        assertImageSnapshot(ofView: sut, name: .iphone13PRO, config: .iPhone13Pro)
    }
    
    func test_ReadMode_empty() {
        let sut = makeSUT(mode: .read)
        assertImageSnapshot(ofView: makeSUT(mode: .read), name: .iphone13PRO, config: .iPhone13Pro)
    }
    
    private func makeSUT(mode: ListenScreenMode) -> ListenScreenView {
        return ListenScreenView(mode: mode, isAnimating: false, viewModel: ListenScreenViewModelStub())
    }
}

final class ListenScreenViewModelStub: ListenScreenViewModelProtocol {
    var isPlaying: AnyPublisher<Bool, Never> { Empty().eraseToAnyPublisher() }
    
    var currentChapter: BookListener.Chapter?
    
    var currentDurationInSeconds: Double = 0.0
    
    func reverse() {
    }
    
    func forward() {
    }
    
    func previous() {
    }
    
    func next() {
    }
    
    func togglePlayPause() {
    }
}
