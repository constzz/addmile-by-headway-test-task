//
//  ListenScreenMode.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

enum ListenScreenMode: Int, CaseIterable {
    case listen
    case read

    var image: some View {
        let image = switch self {
        case .listen:
            Image(systemName: "headphones")
        case .read:
            Image(systemName: "text.alignleft")
        }
        return image
            .renderingMode(.template)
            .font(.system(size: 18, weight: .bold))
    }
}
