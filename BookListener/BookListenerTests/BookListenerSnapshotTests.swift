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
        let view = ContentView()
        assertImageSnapshot(ofView: view, name: "iphone13PRO", config: .iPhone13Pro)
        assertImageSnapshot(ofView: view, name: "iphoneSE", config: .iPhoneSe)
    }
}
