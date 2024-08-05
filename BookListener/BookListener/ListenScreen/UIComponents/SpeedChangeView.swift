//
//  SpeedChangeView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 05.08.2024.
//

import Foundation
import SwiftUI
import Combine

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
        }
        .padding(10)
        .background(.darkBiege)
        .foregroundColor(.dark)
        .cornerRadius(6)
        .onReceive(speedValueFormattedPublisher) { newValue in
            speedValueFormatted = newValue
        }
    }
}

