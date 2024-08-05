//
//  ListenScreenSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

@testable import BookListener
import Combine
import XCTest

// MARK: - ListenScreenSnapshotTests

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
        ListenScreenView(isAnimating: false, viewModel: ListenScreenViewModelStub(mode: .init(mode)))
    }
}

// MARK: - ListenScreenViewModelStub

final class ListenScreenViewModelStub: ListenScreenViewModelProtocol {
    var errorPublisher: AnyPublisher<String, Never> { Empty().eraseToAnyPublisher() }
    var mode: CurrentValueSubject<BookListener.ListenScreenMode, Never>

    lazy var currentTimeInSecondsString: AnyPublisher<String, Never> = currentTimePublisher

    var sliderChangeSubject: PassthroughSubject<Double, Never> = .init()

    var isEditingCurrentTimeSubject: CurrentValueSubject<Bool, Never> = .init(false)

    func onChangeEnd(finalSliderChange _: Double) {}

    init(mode: CurrentValueSubject<BookListener.ListenScreenMode, Never>) {
        self.mode = mode
    }

    var currentSpeedPublisher: AnyPublisher<Double, Never> {
        CurrentValueSubject<Double, Never>(0.0).eraseToAnyPublisher()
    }

    var changePlaybackSpeedSubject: PassthroughSubject<Void, Never> = .init()

    var isPreviousActivePublisher: AnyPublisher<Bool, Never> { CurrentValueSubject(false).eraseToAnyPublisher() }

    var isNextActivePublisher: AnyPublisher<Bool, Never> { Empty().eraseToAnyPublisher() }

    var bookCover: URL?

    var currentChapterPublisher: AnyPublisher<BookListener.Chapter?, Never> {
        CurrentValueSubject(.init(index: 1, title: "title", url: nil)).eraseToAnyPublisher()
    }

    var chaptersCount: Int {
        4
    }

    var isPlayingNonUpdatingValue: Bool = false

    func convertProgresToCurrentTime(progress _: Double) -> String {
        ""
    }

    func seekTo(_: Double) {}

    var durationTimePublisher: AnyPublisher<String, Never> {
        CurrentValueSubject("1:14").eraseToAnyPublisher()
    }

    var progressPublisher: AnyPublisher<Double, Never> {
        CurrentValueSubject(0.0).eraseToAnyPublisher()
    }

    var currentTimePublisher: AnyPublisher<String, Never> {
        CurrentValueSubject("00:00").eraseToAnyPublisher()
    }

    var currentTimeInSeconds: AnyPublisher<Double, Never> { CurrentValueSubject(0.0).eraseToAnyPublisher() }

    var totalDuration: Double { 74.0 }

    var isPlaying: AnyPublisher<Bool, Never> { Empty().eraseToAnyPublisher() }

    var currentChapter: BookListener.Chapter? = .init(index: 0, title: "1 of 4", url: nil)

    func reverse() {}

    func forward() {}

    func previous() {}

    func next() {}

    func togglePlayPause() {}
}
