//
//  BookListenerApp.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 02.08.2024.
//

import SwiftUI

@main
struct BookListenerApp: App {
    
    @State
    var horizontalValuesState: String = ""
    
    @State var value: Double = 50
    
    var body: some Scene {
        WindowGroup {
            VStack {
                SliderView(value: $value, leftLabelValue: .constant(""),
                           rightLabelValue: .constant("5"),
                             onChange: {
                    newValue in
                    horizontalValuesState = value.preciceCeil(to: .tenths).description
                })
            }
        }
    }
}
