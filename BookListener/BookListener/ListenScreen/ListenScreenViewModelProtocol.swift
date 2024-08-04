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
    var currentDurationInSeconds: Double { get }
    func togglePlayPause()
    func reverse()
    func forward()
    func previous()
    func next()
}
