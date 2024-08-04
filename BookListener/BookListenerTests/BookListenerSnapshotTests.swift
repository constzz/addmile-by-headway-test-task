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
        let sut = PlaybackControlView(state: .init(previousAction: {}, reverseAction: {}, playAction: {}, pauseAction: {}, forwardAction: {}, nextAction: {}), isPlayActivePublisher: Empty().eraseToAnyPublisher())
        assertImageSnapshot(ofView: sut, name: .snapshotName300_per_200, config: .config_300_200_pixels)
    }
    
    func test_sliderView_empty() {
        let sut = SliderView(value: .constant(0), leftLabelValue: .constant("0"), rightLabelValue: .constant("100"))
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
        let view = ChapterInfoView()
        self.assertImageSnapshot(ofView: view, name: .snapshotName300_per_200, config: .config_300_200_pixels)
    }
    
    func test_coverImageView() {
        let view = CoverImageView(coverImage: .init(systemName: "book"), foregroundColor: .dark)
        self.assertImageSnapshot(ofView: view, name: .snapshotName200_per_300, config: .config_200_300_pixels)
    }
}
