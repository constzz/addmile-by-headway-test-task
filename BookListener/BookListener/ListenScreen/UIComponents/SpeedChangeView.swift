//
//  SpeedChangeView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 05.08.2024.
//

import Combine
import Foundation
import SwiftUI

// MARK: - SpeedChangeView

struct SpeedChangeView: View {
    let changePlaybackSpeed: any Subject<Void, Never>
    let speedValueFormattedPublisher: AnyPublisher<String, Never>

    init(changePlaybackSpeed: any Subject<Void, Never>, speedValueFormattedPublisher: AnyPublisher<String, Never>) {
        self.changePlaybackSpeed = changePlaybackSpeed
        self.speedValueFormattedPublisher = speedValueFormattedPublisher
    }

    @State private var speedValueFormatted: String = ""

    var body: some View {
        Button(action: {
            changePlaybackSpeed.send()
        }) {
            Text("Speed x\(speedValueFormatted)")
                .font(.system(size: 13, weight: .medium, design: .default))
                .animation(nil)
        }
        .padding(10)
        .background(.darkBiege)
        .foregroundColor(.dark)
        .cornerRadius(6)
        .buttonStyle(NonHighlitedButton())
        .onReceive(speedValueFormattedPublisher) { newValue in
            speedValueFormatted = newValue
        }
    }
}

// MARK: - NonHighlitedButton

private struct NonHighlitedButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
