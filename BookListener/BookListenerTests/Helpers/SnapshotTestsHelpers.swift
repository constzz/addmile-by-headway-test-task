//
//  SnapshotTestsHelpers.swift
//  BookListenerTests
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import XCTest
import SwiftUI
import SnapshotTesting


extension XCTestCase {
    
    private var testingUIUserInterfaceStyles: [UIUserInterfaceStyle] {
        [.light, .dark]
    }
    
    func assertImageSnapshot<Value: View>(
        ofView view: Value,
        name: String?,
        config: ViewImageConfig,
        fileID: StaticString = #fileID,
        file filePath: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        var config = config
        testingUIUserInterfaceStyles.forEach({ style in
            assertSnapshot(
                of: view,
                as: .image(layout: .device(config: config.withUserInterfaceStyle(style))),
                named: name?.appending("_\(style.title)"),
                fileID: fileID,
                file: filePath,
                testName: testName,
                line: line,
                column: column
            )
        })
    }
}

extension String {
    static var snapshotName300_per_200: String {
        "300_200_pixels"
    }
    
    static var snapshotName400_per_200: String {
        "400_200_pixels"
    }
}

extension ViewImageConfig {
    static var config_300_200_pixels: Self {
        return .init(size: .init(width: 300, height: 200))
    }
    
    static var config_400_200_pixels: Self {
        return .init(size: .init(width: 400, height: 200))
    }
    
    mutating func withUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        self.traits = self.traits.modifyingTraits({ $0.userInterfaceStyle = style})
        return self
    }
}

extension UIUserInterfaceStyle {
    var title: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .light:
            return "light"
        case .dark:
            return "dark"
        @unknown default:
            return "unknown"
        }
    }
}
