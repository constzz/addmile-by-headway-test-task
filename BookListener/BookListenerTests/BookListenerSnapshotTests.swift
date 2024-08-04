//
//  BookListenerSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

@testable import BookListener
import XCTest

class BookListenerSnapshotTests: XCTestCase {
    
    func test_emptyScreen() {
        let sut = ContentView()
        assertImageSnapshot(ofView: sut, name: "iphone13PRO", config: .iPhone13Pro)
        assertImageSnapshot(ofView: sut, name: "iphoneSE", config: .iPhoneSe)
    }
    
    func test_playbackControlView() {
        let sut = PlaybackControlView()
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
}
