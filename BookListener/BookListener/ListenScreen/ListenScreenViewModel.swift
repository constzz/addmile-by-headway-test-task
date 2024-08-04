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
    
    var currentDurationInSeconds: AnyPublisher<Double, Never> {
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
    
    private lazy var currentChapterSubject = CurrentValueSubject<Chapter?, Never>(currentChapter)
    
    private(set) var currentChapter: Chapter? {
        didSet { onCurrentChapterUpdate(chapter: currentChapter) }
    }
        
    var chaptersCount: Int {
        book.chapters.count
    }
    
    private let book: Book
    private let audioViewModel: AudioViewModelProtocol
    
    var progressPublisher: AnyPublisher<Double, Never> {
        currentDurationInSeconds
            .map { [totalDuration] duration in
                return duration / totalDuration * 100
            }
            .eraseToAnyPublisher()
    }
    
    var currentTimePublisher: AnyPublisher<String, Never> {
        currentDurationInSeconds
            .map { [dateComponentsFormatter] in
                return dateComponentsFormatter.string(from: $0) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    var durationTimePublisher: AnyPublisher<String, Never> {
        CurrentValueSubject(dateComponentsFormatter.string(from: totalDuration) ?? "")
            .eraseToAnyPublisher()
    }
    
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
        onCurrentChapterUpdate(chapter: self.currentChapter)
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
        if let url = currentChapter?.url {
            try? audioViewModel.set(url: url)
        } else {
            audioViewModel.pause()
        }
    }
}
