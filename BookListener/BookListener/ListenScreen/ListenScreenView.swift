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
    private let viewModel: ListenScreenViewModelProtocol
    private let sliderChangeSubject: PassthroughSubject<Double, Never> = .init()
    @State private var wasPlayingBeforeSliderChange: Bool = false
    @State private var isEditingCurrentTime: Bool = false
                
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
                    valuePublisher: viewModel.progressPublisher
                        .combineLatest(sliderChangeSubject.eraseToAnyPublisher())
                        .map { constantProgressUpdate, sliderChange in
                            return isEditingCurrentTime ? sliderChange : constantProgressUpdate
                        }
                        .eraseToAnyPublisher(),
                    leftLabelValuePublisher: viewModel.currentTimePublisher
                        .combineLatest(sliderChangeSubject.eraseToAnyPublisher())
                        .map { currentTime, sliderChange in
                            return isEditingCurrentTime
                            ? viewModel.convertProgresToCurrentTime(progress: sliderChange / 100)
                            : currentTime 
                        }.eraseToAnyPublisher(),
                    rightLabelValuePublisher: viewModel.durationTimePublisher,
                    changeSubject: sliderChangeSubject,
                    onChangeEnd: { finalSliderChange in
                        isEditingCurrentTime = false
                        viewModel.seekTo(finalSliderChange / 100 * viewModel.totalDuration)
                        if wasPlayingBeforeSliderChange && !viewModel.isPlayingNonUpdatingValue {
                            viewModel.togglePlayPause()
                            wasPlayingBeforeSliderChange = false
                        }
                    })
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
        .onAppear {
            sliderChangeSubject.send(0.0)
            viewModel.togglePlayPause()
        }
        .onReceive(sliderChangeSubject
            .dropFirst()
            .debounce(for: 0.01, scheduler: RunLoop.main)
            .map {$0.rounded()}
        ) { sliderChange in
            isEditingCurrentTime = true
            if viewModel.isPlayingNonUpdatingValue {
                viewModel.togglePlayPause()
                wasPlayingBeforeSliderChange = true
            }
        }
    }
}
