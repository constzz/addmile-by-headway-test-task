//
//  AudioViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import Foundation
import AVKit
import Combine

final class AudioViewModel: NSObject, AudioViewModelProtocol {
        
    var player: AVAudioPlayer = .init()
    
    var currentTimeInSeconds: AnyPublisher<Double, Never> {
        currentTimeInSecondsSubject.eraseToAnyPublisher()
    }
    
    private lazy var currentTimeInSecondsSubject: CurrentValueSubject<Double, Never> = .init(0.0)
    
    var totalDurationInSeconds: Double {
        totalDurationInSecondsSubject.value
    }
    
    var totalDurationInSecondsPublisher: AnyPublisher<Double, Never> {
        totalDurationInSecondsSubject.eraseToAnyPublisher()
    }
    
    private var totalDurationInSecondsSubject: CurrentValueSubject<Double, Never> = .init(0.0)
    
    private(set) lazy var isPlaying: Bool = player.isPlaying
    
    private var currentTimeObserver: NSKeyValueObservation?
    
    var speed: Float {
        get { player.rate }
        set { player.rate = newValue }
    }
    
    var onFinishPlaying: (() -> Void)?
    
    private var timer: Timer?
    
    override init() {
        super.init()
    }
    
    func set(url: URL) throws {
        self.player = try .init(contentsOf: url)
        self.player.delegate = self
        
        currentTimeInSecondsSubject.send(player.currentTime)
        totalDurationInSecondsSubject.send(player.duration)
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
        totalDurationInSecondsSubject.send(player.duration.preciceCeil(to: .hundredths))
    }

}

extension AudioViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else {
            return
        }
        self.onFinishPlaying?()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    }
}
