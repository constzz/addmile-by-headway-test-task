//
//  ChapterInfoView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct ChapterInfoView: View {
    
    var body: some View {
        VStack {
            Text("1 of 4")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            Text("title")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .lineLimit(0)
                .frame(maxHeight: 45)
                .lineSpacing(2)
        }
        .padding(.horizontal, 40)
    }
}
