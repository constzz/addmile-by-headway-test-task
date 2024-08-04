//
//  ListenScreenView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI
import Combine

struct ListenScreenView: View {
    
    @State private var mode: ListenScreenMode
    @State private var isAnimating: Bool
    @State private var isPlaying: Bool = false
    private let viewModel: ListenScreenViewModelProtocol
        
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    init(mode: ListenScreenMode, isAnimating: Bool, viewModel: ListenScreenViewModelProtocol) {
        self.mode = mode
        self.isAnimating = isAnimating
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch mode {
            case .listen:
                CoverImageView(coverImage: .init(systemName: "book"), foregroundColor: .dark)
                ChapterInfoView()
                SliderView(
                    valuePublisher: viewModel.progressPublisher,
                    leftLabelValuePublisher: viewModel.currentTimePublisher,
                    rightLabelValuePublisher: viewModel.durationTimePublisher)
                PlaybackControlView(state: .init(
                    previousAction: {},
                    reverseAction: { viewModel.reverse() },
                    playAction: { viewModel.togglePlayPause() },
                    pauseAction: { viewModel.togglePlayPause() },
                    forwardAction: { viewModel.forward() },
                    nextAction: {}),
                                    isPlayActivePublisher: viewModel.isPlaying
                )
            case .read:
                Rectangle()
                    .foregroundStyle(.darkBiege)
                    .padding()
            }
            ToggleView(listenScreenMode: $mode, isAnimating: $isAnimating)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(.biege)
        .onAppear { viewModel.togglePlayPause() }
        .onReceive(viewModel.currentDurationInSeconds) { _ in
            
        }
    }
}
