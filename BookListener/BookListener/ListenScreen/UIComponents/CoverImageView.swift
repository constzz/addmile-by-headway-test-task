//
//  CoverImageView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

struct CoverImageView: View {
    var coverImage: URL?
    var foregroundColor: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.biege)
            
            if let coverImage {
                AsyncImage(url: coverImage)
                    { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .foregroundStyle(foregroundColor)
                    .frame(width: 200, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                Image(systemName: "book")
                    .resizable()
                    .foregroundStyle(foregroundColor)
                    .frame(width: 200, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                
            }
        }
    }
}
