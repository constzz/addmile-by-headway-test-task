//
//  PlaybackControlView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct PlaybackControlView: View {
    var state: State?
    
    var body: some View {
        HStack {
            Button(action: { state?.previousAction() },
                   label: { Role.previous.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())
            .disabled(true)
            
            Button(action: { state?.reverseAction() },
                   label: { Role.reverse.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())

            Button(action: { state?.playAction() },
                   label: { Role.play.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())
            
            Button(action: { state?.forwardAction() },
                   label: { Role.forward.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())
            
            Button(action: { state?.nextAction() },
                   label: { Role.next.imageView })
            .buttonStyle(PlaybackControlViewButtonStyle())
        }
    }
}


extension PlaybackControlView {
    struct State {
        let previousAction: () -> Void
        let reverseAction: () -> Void
        let playAction: () -> Void
        let pauseAction: () -> Void
        let forwardAction: () -> Void
        let nextAction: () -> Void
    }
}
