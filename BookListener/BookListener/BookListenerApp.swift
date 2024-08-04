//
//  BookListenerApp.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 02.08.2024.
//

import SwiftUI

@main
struct BookListenerApp: App {
    
    var body: some Scene {
        WindowGroup {
            VStack {
                ListenScreenView(mode: .listen, isAnimating: true)
            }
        }
    }
}
