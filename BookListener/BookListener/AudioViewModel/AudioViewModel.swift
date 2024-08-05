//
//  AudioViewModel.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import AVKit
import Combine
import Foundation

// MARK: - AudioViewModel

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
        player = try .init(contentsOf: url)
        player.delegate = self
        player.enableRate = true

        currentTimeInSecondsSubject.send(0.0)
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
        currentTimeInSecondsSubject.send(value)
    }

    func changePlaybackSpeed(_ speed: Float) {
        self.speed = speed
    }

    func forward(seconds: Double) {
        let newValue = Double(player.currentTime) + seconds
        if newValue > totalDurationInSecondsSubject.value {
            seekTo(totalDurationInSecondsSubject.value - 0.1)
        } else {
            seekTo(Double(player.currentTime) + seconds)
        }
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

// MARK: AVAudioPlayerDelegate

extension AudioViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        guard flag else {
            return
        }
        onFinishPlaying?()
    }

    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) {}
}
