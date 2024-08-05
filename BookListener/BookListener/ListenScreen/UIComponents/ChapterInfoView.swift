//
//  ChapterInfoView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Combine
import SwiftUI

struct ChapterInfoView: View {
    @State private var subtitle: String = ""
    @State private var mainTitle: String = ""
    private let subtitlePublisher: AnyPublisher<String, Never>
    private let mainTitlePublisher: AnyPublisher<String, Never>

    init(
        subtitlePublisher: AnyPublisher<String, Never>,
        mainTitlePublisher: AnyPublisher<String, Never>
    ) {
        self.subtitlePublisher = subtitlePublisher
        self.mainTitlePublisher = mainTitlePublisher
    }

    var body: some View {
        VStack {
            Text(subtitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            Text(mainTitle)
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .lineLimit(0)
                .frame(maxHeight: 45)
                .lineSpacing(2)
        }
        .padding(.horizontal, 40)
        .onReceive(subtitlePublisher) { title in
            subtitle = title
        }
        .onReceive(mainTitlePublisher) { title in
            mainTitle = title
        }
    }
}
