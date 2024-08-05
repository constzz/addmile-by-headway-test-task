//
//  Mocks.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 05.08.2024.
//

import Foundation

// No localizations here, data is expected to be mock only

enum Mock {
    static let thinkAndGrowRich0File: URL? = Bundle.main.url(forResource: "00 Introduction", withExtension: "mp3")
    static let thinkAndGrowRich1File: URL? = Bundle.main.url(forResource: "01 Chapter 1", withExtension: "mp3")
    static let thinkAndGrowRich2File: URL? = Bundle.main.url(forResource: "02 Chapter 2", withExtension: "mp3")
    static let thinkAndGrowRich3File: URL? = Bundle.main.url(forResource: "03 Chapter 3", withExtension: "mp3")
    static let thinkAndGrowRich4File: URL? = Bundle.main.url(forResource: "04 Chapter 4", withExtension: "mp3")
    static let thinkAndGrowRich5File: URL? = Bundle.main.url(forResource: "05 Chapter 5", withExtension: "mp3")
    static let thinkAndGrowRichBookCover: URL? = Bundle.main.url(forResource: "think_and_grow_rich_book_cover", withExtension: "jpg")

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
        coverURL: thinkAndGrowRichBookCover)

}

