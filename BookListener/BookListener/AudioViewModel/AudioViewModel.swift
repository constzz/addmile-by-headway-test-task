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
    
    private(set) lazy var isPlaying: Bool = player.isPlaying
    
    var speed: Float {
        get { player.rate }
        set { player.rate = newValue }
    }
    
    init(book: Book) {
        self.book = book
        self.player = (try? .init(contentsOf: book.url)) ?? .init()
        // TODO: implement delegate
        player.delegate = AudioDelegate(didFinishPlaying: { bool in
            print("did finish playing")
        }, decodeErrorDidOccur: { error in
            print("error occured")
        })
    }
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func seekTo(_ value: Double) {
        player.currentTime = value
    }
    
    func changePlaybackSpeed(_ speed: Float) {
        self.speed = speed
    }
}

private final class AudioDelegate: NSObject, AVAudioPlayerDelegate {
    private let didFinishPlaying: (Bool) -> Void
    private let decodeErrorDidOccur: (Error?) -> Void
    
    init(
        didFinishPlaying: @escaping (Bool) -> Void,
        decodeErrorDidOccur: @escaping (Error?) -> Void
    ) {
        self.didFinishPlaying = didFinishPlaying
        self.decodeErrorDidOccur = decodeErrorDidOccur
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.didFinishPlaying(flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.decodeErrorDidOccur(error)
    }
}



