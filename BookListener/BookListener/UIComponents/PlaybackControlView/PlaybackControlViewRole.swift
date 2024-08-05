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
            let image = switch self {
            case .previous:
                Image(systemName: "backward.end.fill")
            case .reverse:
                Image(systemName: "gobackward.5")
            case .play:
                Image(systemName: "play.fill")
            case .pause:
                Image(systemName: "pause.fill")
            case .forward:
                Image(systemName: "goforward.10")
            case .next:
                Image(systemName: "forward.end.fill")
            }
            return image
                .renderingMode(.template)
                .foregroundColor(.dark)
        }
    }
}
