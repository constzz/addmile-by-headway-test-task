//
//  AudioViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation
import AVKit
import Combine

final class AudioViewModel: AudioViewModelProtocol {
    
    let player: AVAudioPlayer
    let book: Book
    
    var currentTimeInSeconds: AnyPublisher<Double, Never> {
        currentTimeInSecondsSubject.eraseToAnyPublisher()
    }
    
    private lazy var currentTimeInSecondsSubject: CurrentValueSubject<Double, Never> = .init(0.0)
    
    var totalDurationInSeconds: Double {
        player.duration
    }
    
    private(set) lazy var isPlaying: Bool = player.isPlaying
    
    private var currentTimeObserver: NSKeyValueObservation?
    
    var speed: Float {
        get { player.rate }
        set { player.rate = newValue }
    }
    
    private var timer: Timer?
    
    init(book: Book) {
        self.book = book
        self.player = (try? .init(contentsOf: book.url)) ?? .init()
        // TODO: implement delegate
        player.delegate = AudioDelegate(didFinishPlaying: { bool in
            print("did finish playing")
        }, decodeErrorDidOccur: { error in
            print("error occured")
        })
        currentTimeInSecondsSubject.send(player.currentTime)
        setupTimer()
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
        self.currentTimeInSecondsSubject.send(value)
    }
    
    func changePlaybackSpeed(_ speed: Float) {
        self.speed = speed
    }
    
    func forward(seconds: Double) {
        seekTo(Double(player.currentTime) + seconds)
    }
    
    func reverse(seconds: Double) {
        seekTo(Double(player.currentTime) - seconds)
    }
    
}

private extension AudioViewModel {
    func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(playerTimerAction), userInfo: nil, repeats: true)
        timer?.fireDate = Date()
    }

    @objc private func playerTimerAction() {
        currentTimeInSecondsSubject.send(player.currentTime.preciceCeil(to: .hundredths))
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



