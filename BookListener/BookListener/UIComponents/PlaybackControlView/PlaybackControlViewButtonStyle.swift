//
//  PlaybackControlViewButtonStyle.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct PlaybackControlViewButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .background(configuration.isPressed ? Circle().foregroundColor(.init(.systemGray5)) : nil)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(Animation.linear(duration: 0.2),
                       value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
            .imageScale(.large)
    }
}
