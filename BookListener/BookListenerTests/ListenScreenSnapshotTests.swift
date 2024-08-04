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
        assertImageSnapshot(ofView: sut, name: .iphone13PRO, config: .iPhone13Pro)
    }
    
    private func makeSUT(mode: ListenScreenMode) -> ListenScreenView {
        return ListenScreenView(mode: mode, isAnimating: false, viewModel: ListenScreenViewModelStub())
    }
}

final class ListenScreenViewModelStub: ListenScreenViewModelProtocol {
    var durationTimePublisher: AnyPublisher<String, Never> {
        CurrentValueSubject("1:14").eraseToAnyPublisher()
    }
    
    var progressPublisher: AnyPublisher<Double, Never> {
        CurrentValueSubject(0.0).eraseToAnyPublisher()
    }
    
    var currentTimePublisher: AnyPublisher<String, Never> {
        CurrentValueSubject("00:00").eraseToAnyPublisher()
    }
    
    var currentDurationInSeconds: AnyPublisher<Double, Never> { CurrentValueSubject(0.0).eraseToAnyPublisher() }
    
    var totalDuration: Double { 74.0 }
    
    var isPlaying: AnyPublisher<Bool, Never> { Empty().eraseToAnyPublisher() }
    
    var currentChapter: BookListener.Chapter?
    
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
