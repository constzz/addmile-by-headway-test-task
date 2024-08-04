//
//  ListenScreenSnapshotTests.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 04.08.2024.
//

import XCTest
@testable import BookListener

final class ListenScreenSnapshotTests: XCTestCase {
    func test_emptyScreen() {
        let sut = ListenScreenView(isAnimating: false)
        assertImageSnapshot(ofView: sut, name: .iphone13PRO, config: .iPhone13Pro)
    }
}
