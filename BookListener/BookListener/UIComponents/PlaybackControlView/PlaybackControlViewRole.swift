//
//  PlaybackControlViewRole.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI

extension PlaybackControlView {
    enum Role {
        case previous
        case reverse
        case play
        case pause
        case forward
        case next
         
        var imageView: some View {
            let image = {
                switch self {
                case .previous:
                    return Image(systemName: "backward.end.fill")
                case .reverse:
                    return Image(systemName: "gobackward.5")
                case .play:
                    return Image(systemName: "play.fill")
                case .pause:
                    return Image(systemName: "pause.fill")
                case .forward:
                    return Image(systemName: "goforward.10")
                case .next:
                    return Image(systemName: "forward.end.fill")
                }
            }()
            return image
                .renderingMode(.template)
                .foregroundColor(.dark)
        }
    }
}
