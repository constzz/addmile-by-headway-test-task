//
//  ListenScreenViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine
import Foundation

final class ListenScreenViewModel: ListenScreenViewModelProtocol {
    
    var totalDuration: Double {
        audioViewModel.totalDurationInSeconds
    }
    
    var currentTimeInSeconds: AnyPublisher<Double, Never> {
        audioViewModel.currentTimeInSeconds
    }

    var isPlaying: AnyPublisher<Bool, Never> {
        isPlayingSubject.eraseToAnyPublisher()
    }
    let isPlayingSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    var isPlayingNonUpdatingValue: Bool { isPlayingSubject.value }
    
    var currentChapterPublisher: AnyPublisher<Chapter?, Never> {
        currentChapterSubject.eraseToAnyPublisher()
    }
    
    var currentSpeedPublisher: AnyPublisher<Double, Never> {
        currentSpeedSubject.eraseToAnyPublisher()
    }
    
    let changePlaybackSpeedSubject = PassthroughSubject<Void, Never>()
    private let currentSpeedSubject = CurrentValueSubject<Double, Never>(1.0)
        
    private lazy var currentChapterSubject = CurrentValueSubject<Chapter?, Never>(currentChapter)
    
    private(set) var currentChapter: Chapter? {
        didSet { onCurrentChapterUpdate(chapter: currentChapter) }
    }
        
    var chaptersCount: Int {
        book.chapters.count
    }
    
    var bookCover: URL? {
        book.coverURL
    }
        
    var progressPublisher: AnyPublisher<Double, Never> {
        currentTimeInSeconds
            .combineLatest(audioViewModel.totalDurationInSecondsPublisher)
            .map { currentTimeInSeconds, duration in
                return currentTimeInSeconds / duration * 100
            }
            .eraseToAnyPublisher()
    }
    
    var currentTimePublisher: AnyPublisher<String, Never> {
        currentTimeInSeconds
            .map { [dateComponentsFormatter] in
                return dateComponentsFormatter.string(from: $0) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    var durationTimePublisher: AnyPublisher<String, Never> {
        audioViewModel.totalDurationInSecondsPublisher
            .map { [dateComponentsFormatter] in
                return dateComponentsFormatter.string(from: $0) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    var isPreviousActivePublisher: AnyPublisher<Bool, Never> {
        isPreviousActiveSubject.eraseToAnyPublisher()
    }
    
    private let isPreviousActiveSubject = CurrentValueSubject<Bool, Never>(true)
    
    var isNextActivePublisher: AnyPublisher<Bool, Never> {
        isNextActiveSubject.eraseToAnyPublisher()
    }
    
    private let isNextActiveSubject = CurrentValueSubject<Bool, Never>(true)
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    
    private enum Constants {
        static let reverseDurationAmountInSeconds = 5.0
        static let forwardDurationAmountInSeconds = 10.0
    }
    
    private let book: Book
    private var audioViewModel: AudioViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        book: Book,
        defaultChapterIndex: Int?,
        audioViewModel: AudioViewModelProtocol
    ) {
        self.book = book
        if let defaultChapterIndex, let firstChapter = book.chapters.safelyRetrieve(elementAt: defaultChapterIndex) {
            self.currentChapter = firstChapter
        } else {
            self.currentChapter = book.chapters.first
        }
        self.audioViewModel = audioViewModel
        self.audioViewModel.onFinishPlaying = { [weak self] in
            self?.next()
        }
        onCurrentChapterUpdate(chapter: self.currentChapter)
        changePlaybackSpeedSubject.sink { [weak self] _ in
            guard let self else { return }
            var newValue = self.currentSpeedSubject.value + 0.25
            if newValue > 2.0 {
                newValue = 0.25
            }
            self.audioViewModel.speed = Float(newValue)
            self.currentSpeedSubject.send(newValue)
        }.store(in: &cancellables)
    }
    
    func togglePlayPause() {
        isPlayingSubject.send(!isPlayingSubject.value)
        isPlayingSubject.value ? audioViewModel.play() : audioViewModel.pause()
    }
    
    func forward() {
        audioViewModel.forward(seconds: Constants.forwardDurationAmountInSeconds)
    }
    
    func reverse() {
        audioViewModel.reverse(seconds: Constants.reverseDurationAmountInSeconds)
    }
    
    func previous() {
        guard let currentChapter else { return }
        if let previousChapter = book.chapters.safelyRetrieve(elementAt: currentChapter.index - 1) {
            self.currentChapter = previousChapter
        }
    }
    
    func next() {
        guard let currentChapter else { return }
        if let nextChapter = book.chapters.safelyRetrieve(elementAt: currentChapter.index + 1) {
            self.currentChapter = nextChapter
        }
    }
    
    func seekTo(_ value: Double) {
        audioViewModel.seekTo(value)
    }
    
    func convertProgresToCurrentTime(progress: Double) -> String {
        dateComponentsFormatter.string(from: progress * totalDuration) ?? ""
    }
    
    private func onCurrentChapterUpdate(chapter: Chapter?) {
        currentChapterSubject.send(currentChapter)
        
        if let chapter {
            let previousIndex = chapter.index - 1
            isPreviousActiveSubject.send(book.chapters.safelyRetrieve(elementAt: previousIndex) != nil)
            
            let nextIndex = chapter.index + 1
            isNextActiveSubject.send(book.chapters.safelyRetrieve(elementAt: nextIndex) != nil)
        } else {
            isPreviousActiveSubject.send(false)
            isNextActiveSubject.send(false)
        }
        
        
        if let url = currentChapter?.url {
            try? audioViewModel.set(url: url)
            audioViewModel.play()
        } else {
            audioViewModel.pause()
        }
    }
}
