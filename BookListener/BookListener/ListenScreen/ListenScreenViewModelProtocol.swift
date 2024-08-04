//
//  ListenScreenViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine

protocol ListenScreenViewModelProtocol {
    var isPlaying: AnyPublisher<Bool, Never> { get }
    var currentChapter: Chapter? { get }
    var currentDurationInSeconds: AnyPublisher<Double, Never> { get }
    var progressPublisher: AnyPublisher<Double, Never> { get }
    var currentTimePublisher: AnyPublisher<String, Never> { get }
    var durationTimePublisher: AnyPublisher<String, Never> { get }
    var totalDuration: Double { get }
    func togglePlayPause()
    func reverse()
    func forward()
    func previous()
    func next()
}
