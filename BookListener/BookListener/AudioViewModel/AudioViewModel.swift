//
//  AudioViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation
import AVKit

final class AudioViewModel: AudioViewModelProtocol {
    
    let player: AVAudioPlayer
    let book: Book
    
    var currentTimeInSeconds: Double {
        player.currentTime
    }
    
    var speed: Float {
        get { player.rate }
        set { player.rate = newValue }
    }
    
    init(book: Book) {
        self.book = book
        self.player = (try? .init(contentsOf: book.url)) ?? .init()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func seekTo(_ value: Double) {
        player.currentTime = value
    }
    
    func changePlaybackSpeed(_ speed: Float) {
        self.speed = speed
    }

}
