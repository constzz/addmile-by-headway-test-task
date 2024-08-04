//
//  CoverImageView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct CoverImageView: View {
    var coverImage: Image
    var foregroundColor: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.biege)
            coverImage
                .resizable()
                .foregroundStyle(foregroundColor)
                .frame(width: 200, height: 300)
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
    }
}
