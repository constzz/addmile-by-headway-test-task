//
//  ListenScreenViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine

final class ListenScreenViewModel: ListenScreenViewModelProtocol {
    private(set) var currentDurationInSeconds: Double {
        get { audioViewModel.currentTimeInSeconds }
        set { audioViewModel.seekTo(newValue) }
    }
    var isPlaying: AnyPublisher<Bool, Never> {
        isPlayingSubject.eraseToAnyPublisher()
    }
    let isPlayingSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var currentChapter: Chapter?
    private let chapters: [Chapter]
    private let audioViewModel: AudioViewModelProtocol
    
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
        self.currentDurationInSeconds = currentDurationInSeconds ?? 0.0
    }
    
    func togglePlayPause() {
        isPlayingSubject.send(!isPlayingSubject.value)
        isPlayingSubject.value ? audioViewModel.play() : audioViewModel.pause()
    }
    
    func forward() {
        self.currentDurationInSeconds += Constants.forwardDurationAmountInSeconds
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
