//
//  AudioViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine
import Foundation

struct Book {
    let url: URL = Bundle.main.url(forResource: "00 Introduction", withExtension: "mp3")!
}

protocol AudioViewModelProtocol {
    var currentTimeInSeconds: AnyPublisher<Double, Never> { get }
    var totalDurationInSeconds: Double { get }
    var speed: Float { get }
    var isPlaying: Bool { get }
    func play()
    func pause()
    func seekTo(_ value: Double)
    func forward(seconds: Double)
    func reverse(seconds: Double)
}
