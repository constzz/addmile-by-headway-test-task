//
//  BookListenerSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

@testable import BookListener
import XCTest
import Combine

class BookListenerSnapshotTests: XCTestCase {
        
    func test_playbackControlView() {
        let sut = PlaybackControlView(state: .init(previousAction: {}, reverseAction: {}, playAction: {}, pauseAction: {}, forwardAction: {}, nextAction: {}), isPlayActivePublisher: Empty().eraseToAnyPublisher(), isPreviousActivePublisher: CurrentValueSubject(false).eraseToAnyPublisher(), isNextActivePublisher: Empty().eraseToAnyPublisher())
        assertImageSnapshot(ofView: sut, name: .snapshotName300_per_200, config: .config_300_200_pixels)
    }
    
    func test_sliderView_empty() {
        let sut = SliderView(
            valuePublisher: CurrentValueSubject(0.0).eraseToAnyPublisher(),
            leftLabelValuePublisher: CurrentValueSubject("00:00").eraseToAnyPublisher(),
            rightLabelValuePublisher: CurrentValueSubject("1:14").eraseToAnyPublisher(),
            changeSubject: PassthroughSubject())
        assertImageSnapshot(ofView: sut, name: .snapshotName400_per_200, config: .config_400_200_pixels)
    }
    
    func test_toggleView_listenMode() {
        let view = ToggleView(
            listenScreenMode: .constant(.listen), isAnimating: .constant(false)
        )
        self.assertImageSnapshot(ofView: view, name: .snapshotName400_per_200, config: .config_400_200_pixels)
    }
    
    func test_toggleView_readMode() {
        let view = ToggleView(
            listenScreenMode: .constant(.read), isAnimating: .constant(false)
        )
        self.assertImageSnapshot(ofView: view, name: .snapshotName400_per_200, config: .config_400_200_pixels)
    }
    
    func test_chapterInfoView() {
        let view = ChapterInfoView(
            subtitlePublisher: CurrentValueSubject("1 of 4").eraseToAnyPublisher(),
            mainTitlePublisher: CurrentValueSubject("title").eraseToAnyPublisher())
        self.assertImageSnapshot(ofView: view, name: .snapshotName300_per_200, config: .config_300_200_pixels)
    }
    
    func test_coverImageView() {
        let view = CoverImageView(coverImage: nil, foregroundColor: .dark)
        self.assertImageSnapshot(ofView: view, name: .snapshotName200_per_300, config: .config_200_300_pixels)
    }
}
