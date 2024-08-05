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
    private let subtitleSubject = PassthroughSubject<String, Never>()
    private let mainTitleSubject = PassthroughSubject<String, Never>()
                
    init(mode: ListenScreenMode, isAnimating: Bool, viewModel: ListenScreenViewModelProtocol) {
        self.mode = mode
        self.isAnimating = isAnimating
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch mode {
            case .listen:
                CoverImageView(coverImage: viewModel.bookCover, foregroundColor: .dark)
                ChapterInfoView(
                    subtitlePublisher: subtitleSubject.eraseToAnyPublisher(),
                    mainTitlePublisher: mainTitleSubject.eraseToAnyPublisher())
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
                        let newValueInSeconds = finalSliderChange / 100 * viewModel.totalDuration
                        viewModel.seekTo(newValueInSeconds)
                        if wasPlayingBeforeSliderChange && !viewModel.isPlayingNonUpdatingValue {
                            viewModel.togglePlayPause()
                            wasPlayingBeforeSliderChange = false
                        }
                        if newValueInSeconds == viewModel.totalDuration {
                            viewModel.next()
                        }
                    })
                PlaybackControlView(state: .init(
                    previousAction: { viewModel.previous() },
                    reverseAction: { viewModel.reverse() },
                    playAction: { viewModel.togglePlayPause() },
                    pauseAction: { viewModel.togglePlayPause() },
                    forwardAction: { viewModel.forward() },
                    nextAction: { viewModel.next() }),
                                    isPlayActivePublisher: viewModel.isPlaying,
                                    isPreviousActivePublisher: viewModel.isPreviousActivePublisher,
                                    isNextActivePublisher: viewModel.isNextActivePublisher
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
        .onReceive(viewModel.currentChapterPublisher) { chapter in
            guard let chapter else { return print("Failed to load ")}
            self.subtitleSubject.send("\(chapter.index) of \(viewModel.chaptersCount)")
            self.mainTitleSubject.send(chapter.title)
        }
    }
}
