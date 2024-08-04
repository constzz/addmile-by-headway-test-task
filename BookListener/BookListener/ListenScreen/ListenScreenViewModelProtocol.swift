//
//  ListenScreenViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation

protocol ListenScreenViewModelProtocol {
    var isPlaying: Bool { get }
    var currentChapter: Chapter? { get }
    var currentDurationInSeconds: Double { get }
    func togglePlayPause()
    func reverse()
    func forward()
    func previous()
    func next()
}
