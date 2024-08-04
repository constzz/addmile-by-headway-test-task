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
    private(set) var currentChapter: Chapter?
    private let chapters: [Chapter]
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
        currentDurationInSeconds: Double? = nil,
        chapters: [Chapter],
        defaultChapterIndex: Int?,
        audioViewModel: AudioViewModelProtocol
    ) {
        self.chapters = chapters
        if let defaultChapterIndex, let firstChapter = chapters.safelyRetrieve(elementAt: defaultChapterIndex) {
            self.currentChapter = firstChapter
        } else {
            self.currentChapter = chapters.first
        }
        self.audioViewModel = audioViewModel
        self.audioViewModel.seekTo(currentDurationInSeconds ?? 0.0)
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
