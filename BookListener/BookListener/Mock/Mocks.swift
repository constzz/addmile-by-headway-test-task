//
//  Mocks.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 05.08.2024.
//

import Foundation

// No localizations here, data is expected to be mock only

enum Mock {
    static let thinkAndGrowRich0File: URL? = R.file.introductionMp3()
    static let thinkAndGrowRich1File: URL? = R.file.chapter1Mp3()
    static let thinkAndGrowRich2File: URL? = R.file.chapter2Mp3()
    static let thinkAndGrowRich3File: URL? = R.file.chapter3Mp3()
    static let thinkAndGrowRich4File: URL? = R.file.chapter4Mp3()
    static let thinkAndGrowRich5File: URL? = R.file.chapter5Mp3()
    static let thinkAndGrowRichBookCover: URL? = R.file.think_and_grow_rich_book_coverJpg()

    static let thinkAndGrowRichFileURLs: [URL?] = [
        thinkAndGrowRich0File,
        thinkAndGrowRich1File,
        thinkAndGrowRich2File,
        thinkAndGrowRich3File,
        thinkAndGrowRich4File,
        thinkAndGrowRich5File,
    ]

    static let mockedThinkAndGrowRichBook: Book = .init(
        chapters: thinkAndGrowRichFileURLs.enumerated().map { index, url in
            .init(index: index, title: index == 0 ? "Introduction" : "Chapter \(index)", url: url)
        },
        coverURL: thinkAndGrowRichBookCover
    )
}
