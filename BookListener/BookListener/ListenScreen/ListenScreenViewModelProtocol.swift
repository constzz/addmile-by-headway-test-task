//
//  ListenScreenViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine
import Foundation

protocol ListenScreenViewModelProtocol {
    var mode: CurrentValueSubject<ListenScreenMode, Never> { get }
    
    var isPlaying: AnyPublisher<Bool, Never> { get }
    var isPlayingNonUpdatingValue: Bool { get }
    
    var currentChapter: Chapter? { get }
    var currentChapterPublisher: AnyPublisher<Chapter?, Never> { get }
    var chaptersCount: Int { get }
    var bookCover: URL? { get }
    
    var isPreviousActivePublisher: AnyPublisher<Bool, Never> { get }
    var isNextActivePublisher: AnyPublisher<Bool, Never> { get }
    
    var currentSpeedPublisher: AnyPublisher<Double, Never> { get }
    
    var changePlaybackSpeedSubject: PassthroughSubject<Void, Never> { get }
    
    var currentTimeInSeconds: AnyPublisher<Double, Never> { get }
    var currentTimeInSecondsString: AnyPublisher<String, Never> { get }
    
    var sliderChangeSubject: PassthroughSubject<Double, Never> { get }
    var isEditingCurrentTimeSubject: CurrentValueSubject<Bool, Never> { get }
    var progressPublisher: AnyPublisher<Double, Never> { get }
    var currentTimePublisher: AnyPublisher<String, Never> { get }
    var durationTimePublisher: AnyPublisher<String, Never> { get }
    var totalDuration: Double { get }
    func togglePlayPause()
    func reverse()
    func forward()
    func previous()
    func next()
    func seekTo(_ value: Double)
    
    func convertProgresToCurrentTime(progress: Double) -> String
    func onChangeEnd(finalSliderChange: Double)
}
