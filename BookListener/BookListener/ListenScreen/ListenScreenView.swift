//
//  ListenScreenView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Combine
import SwiftUI

struct ListenScreenView: View {
    private enum Constants {
        enum Layout {
            static let spacing = CGFloat(20)
        }
    }

    private let subj = CurrentValueSubject<Void, Never>(())
    @State private var isAnimating: Bool
    @State private var mode: ListenScreenMode = .listen
    @State private var showAlert = false
    @State private var errorMessage: String?
    private let viewModel: ListenScreenViewModelProtocol
    private let subtitleSubject = PassthroughSubject<String, Never>()
    private let mainTitleSubject = PassthroughSubject<String, Never>()

    init(isAnimating: Bool, viewModel: ListenScreenViewModelProtocol) {
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
                    mainTitlePublisher: mainTitleSubject.eraseToAnyPublisher()
                )
                SliderView(
                    valuePublisher: viewModel.progressPublisher,
                    leftLabelValuePublisher: viewModel.currentTimeInSecondsString,
                    rightLabelValuePublisher: viewModel.durationTimePublisher,
                    changeSubject: viewModel.sliderChangeSubject,
                    onChangeEnd: { finalSliderChange in
                        viewModel.onChangeEnd(finalSliderChange: finalSliderChange)
                    }
                )

                SpeedChangeView(
                    changePlaybackSpeed: viewModel.changePlaybackSpeedSubject,
                    speedValueFormattedPublisher: viewModel.currentSpeedPublisher
                        .map { currentSpeed in
                            currentSpeed.description
                        }
                        .eraseToAnyPublisher()
                )
                Spacer(minLength: Constants.Layout.spacing * 2)
                PlaybackControlView(state: .init(
                    previousAction: { viewModel.previous() },
                    reverseAction: { viewModel.reverse() },
                    playAction: { viewModel.togglePlayPause() },
                    pauseAction: { viewModel.togglePlayPause() },
                    forwardAction: { viewModel.forward() },
                    nextAction: { viewModel.next() }
                ),
                isPlayActivePublisher: viewModel.isPlaying,
                isPreviousActivePublisher: viewModel.isPreviousActivePublisher,
                isNextActivePublisher: viewModel.isNextActivePublisher)

            case .read:
                Rectangle()
                    .foregroundStyle(.darkBiege)
                    .padding()
            }
            Spacer(minLength: Constants.Layout.spacing * 2)
            ToggleView(listenScreenModePublisher: viewModel.mode, isAnimating: $isAnimating)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(.biege)
        .onAppear {
            viewModel.sliderChangeSubject.send(0.0)
            if !viewModel.isPlayingNonUpdatingValue {
                viewModel.togglePlayPause()
            }
        }
        .onReceive(viewModel.currentChapterPublisher) { chapter in
            guard let chapter else {
                errorMessage = R.string.localizable.unableToLoadChapter()
                showAlert = true
                return
            }
            subtitleSubject.send(R.string.localizable.chapterSubtitle(chapter.index + 1, viewModel.chaptersCount))
            mainTitleSubject.send(chapter.title)
        }
        .onReceive(viewModel.mode) { mode in
            self.mode = mode
        }
        .alert(isPresented: $showAlert) {
           Alert(
                title: Text(R.string.localizable.error),
                message: Text(errorMessage ?? R.string.localizable.unknownError()),
               dismissButton: .default(Text(R.string.localizable.ok))
           )
       }
    }
}
