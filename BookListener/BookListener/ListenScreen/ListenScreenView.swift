//
//  ListenScreenView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct ListenScreenView: View {
    
    @State private var mode: ListenScreenMode = .listen
    @State var isAnimating: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            switch mode {
            case .listen:
                CoverImageView(coverImage: .init(systemName: "book"), foregroundColor: .dark)
                ChapterInfoView()
                SliderView(value: .constant(50), leftLabelValue: .constant("0.0"), rightLabelValue: .constant("0.0"))
                PlaybackControlView()
            case .read:
                Rectangle()
                    .foregroundStyle(.darkBiege)
                    .padding()
            }
            ToggleView(listenScreenMode: $mode, isAnimating: $isAnimating)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(.biege)
    }
}
