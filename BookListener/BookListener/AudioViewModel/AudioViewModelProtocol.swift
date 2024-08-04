//
//  AudioViewModelProtocol.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation

struct Book {
    let url: URL = Bundle.main.url(forResource: "00 Introduction", withExtension: "mp3")!
}

protocol AudioViewModelProtocol {
    var currentTimeInSeconds: Double { get }
    var speed: Float { get }
    func play()
    func pause()
    func seekTo(_ value: Double)
}
