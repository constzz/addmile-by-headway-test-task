//
//  ListenScreenUIIntegrationTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
import SwiftUI
import UIKit
@testable import BookListener

final class ListenScreenUIIntegrationTests: XCTestCase {
    func test_listenScreen_isPlayingAudioByDefault() async throws {
        let (view, audioViewModel) = makeSUT()
        
        await view.forceRender()
        XCTAssertTrue(audioViewModel.isPlaying)
    }
    
    private func makeSUT(
    ) -> (
        view: some View,
        audioViewModel: AudioViewModelProtocol
    ) {
        let audioViewModel = AudioViewModel(book: .init())
        let listenScreenViewModel = ListenScreenViewModel(
            chapters: createRandomChapters(),
            defaultChapterIndex: 0,
            audioViewModel: audioViewModel)
        let view = ListenScreenView(mode: .listen, isAnimating: false, viewModel: listenScreenViewModel)
        return (view, audioViewModel)
    }
}

extension View {
    func forceRender() async {
        await UIHostingController(rootView: self).forceRender()
    }
}

extension UIHostingController {
    func forceRender() {
        _render(seconds: 0)
    }
}

