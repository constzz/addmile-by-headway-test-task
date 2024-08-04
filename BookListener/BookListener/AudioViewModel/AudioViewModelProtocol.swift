//
//  AudioViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Combine
import Foundation

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
    func set(url: URL) throws
}
