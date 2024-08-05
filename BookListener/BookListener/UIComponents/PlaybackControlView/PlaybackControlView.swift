//
//  PlaybackControlView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Combine
import SwiftUI

// MARK: - PlaybackControlView

struct PlaybackControlView: View {
    let state: Model
    let isPlayActivePublisher: AnyPublisher<Bool, Never>
    let isPreviousActivePublisher: AnyPublisher<Bool, Never>
    let isNextActivePublisher: AnyPublisher<Bool, Never>

    @State private var isPlayActive: Bool = false
    @State private var isPreviousDisabled: Bool = false
    @State private var isNextDisabled: Bool = false

    var body: some View {
        HStack {
            Button(action: { state.previousAction() },
                   label: { Role.previous.imageView })
                .buttonStyle(PlaybackControlViewButtonStyle())
                .disabled(isPreviousDisabled)

            Button(action: { state.reverseAction() },
                   label: { Role.reverse.imageView })
                .buttonStyle(PlaybackControlViewButtonStyle())

            Button(action: { state.playAction() },
                   label: { isPlayActive ? Role.pause.imageView : Role.play.imageView })
                .buttonStyle(PlaybackControlViewButtonStyle())

            Button(action: { state.forwardAction() },
                   label: { Role.forward.imageView })
                .buttonStyle(PlaybackControlViewButtonStyle())

            Button(action: { state.nextAction() },
                   label: { Role.next.imageView })
                .buttonStyle(PlaybackControlViewButtonStyle())
                .disabled(isNextDisabled)
        }
        .onReceive(isPlayActivePublisher) { newValue in
            isPlayActive = newValue
        }
        .onReceive(isPreviousActivePublisher) { isPreviousEnabled in
            isPreviousDisabled = !isPreviousEnabled
        }
        .onReceive(isNextActivePublisher) { isNextEnabled in
            isNextDisabled = !isNextEnabled
        }
    }
}

// MARK: PlaybackControlView.Model

extension PlaybackControlView {
    struct Model {
        let previousAction: () -> Void
        let reverseAction: () -> Void
        let playAction: () -> Void
        let pauseAction: () -> Void
        let forwardAction: () -> Void
        let nextAction: () -> Void
    }
}
