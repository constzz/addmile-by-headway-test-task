//
//  PlaybackControlView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI
import Combine

struct PlaybackControlView: View {
    let state: Model
    let isPlayActivePublisher: AnyPublisher<Bool, Never>
    
    @State
    private var isPlayActive: Bool = false
    
    var body: some View {
        HStack {
            Button(action: { state.previousAction() },
                   label: { Role.previous.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())
            .disabled(true)
            
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
        }.onReceive(isPlayActivePublisher) { newValue in
            isPlayActive = newValue
        }
    }
}


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
