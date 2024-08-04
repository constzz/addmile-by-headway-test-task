//
//  ListenScreenSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
@testable import BookListener

final class ListenScreenSnapshotTests: XCTestCase {
    func test_listenMode_empty() {
        let sut = ListenScreenView(mode: .listen, isAnimating: false)
        assertImageSnapshot(ofView: sut, name: .iphone13PRO, config: .iPhone13Pro)
    }
    
    func test_ReadMode_empty() {
        let sut = ListenScreenView(mode: .read, isAnimating: false)
        assertImageSnapshot(ofView: sut, name: .iphone13PRO, config: .iPhone13Pro)
    }
}
