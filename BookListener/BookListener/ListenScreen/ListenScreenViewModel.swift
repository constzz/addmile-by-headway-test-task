//
//  ListenScreenViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation

final class ListenScreenViewModel: ListenScreenViewModelProtocol {
    private(set) var currentDurationInSeconds: Double
    private(set) var isPlaying: Bool = false
    private(set) var currentChapter: Chapter?
    private let chapters: [Chapter]
    private let audioViewModel: AudioViewModelProtocol
    
    private enum Constants {
        static let reverseDurationAmountInSeconds = 5.0
        static let forwardDurationAmountInSeconds = 1.0
    }
    
    init(
        currentDurationInSeconds: Double? = nil,
        chapters: [Chapter],
        defaultChapterIndex: Int?,
        audioViewModel: AudioViewModelProtocol
    ) {
        self.currentDurationInSeconds = currentDurationInSeconds ?? 0.0
        self.chapters = chapters
        if let defaultChapterIndex, let firstChapter = chapters.safelyRetrieve(elementAt: defaultChapterIndex) {
            self.currentChapter = firstChapter
        } else {
            self.currentChapter = chapters.first
        }
        self.audioViewModel = audioViewModel
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
        isPlaying ? audioViewModel.play() : audioViewModel.pause()
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
