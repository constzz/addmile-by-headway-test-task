//
//  ToggleView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI
import Combine

struct ToggleView: View {
    
    @State private var listenScreenMode: ListenScreenMode = .listen
    private let listenScreenModePublisher: CurrentValueSubject <ListenScreenMode, Never>
    @State private var position: CGFloat = 0
    @State private var size: CGSize = .zero
    @Binding private var isAnimating: Bool
    
    init(
        listenScreenModePublisher: CurrentValueSubject<ListenScreenMode, Never>,
        isAnimating: Binding<Bool>
    ) {
        self.listenScreenModePublisher = listenScreenModePublisher
        self._isAnimating = isAnimating
    }
    
    private let buttonFrameWidth: CGFloat = 54
    private let frameWidth: CGFloat = CGFloat(ListenScreenMode.allCases.count * 60)
    private let buttonHorizontalStackSpacing: CGFloat = 20
    
    var body: some View {
            ZStack {
                ZStack {
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: CGFloat(frameWidth / 2))
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .overlay(RoundedRectangle(cornerRadius: 60).fill(Color.light))
                            .onAppear(perform: {
                                size = proxy.size
                            })
                    }
                    
                    Color.accentBlue.clipShape(Circle())
                        .frame(width: buttonFrameWidth)
                        .offset(x: position - frameWidth)
                    
                    HStack(spacing: buttonHorizontalStackSpacing) {
                        ForEach(ListenScreenMode.allCases, id: \.self) { mode in
                            Button(action: { listenScreenModePublisher.send(mode) },
                                   label: {
                                    mode.image.foregroundColor(listenScreenMode == mode ? .light : .dark)
                                })
                                .buttonStyle(ToggleViewStyle())
                        }
                    }
                }
                .frame(width: frameWidth, height: 60)
                .onAppear {
                    onModeSelected(listenScreenModePublisher.value)
                }
                .onReceive(listenScreenModePublisher.eraseToAnyPublisher()) { mode in
                    onModeSelected(mode)
                }
            }
        }
}

private extension ToggleView {
    func onModeSelected(_ mode: ListenScreenMode) {
        withAnimation(isAnimating ? .smooth : nil) {
            listenScreenMode = mode
            position = positionForMode(mode: mode)
        }

    }
    func positionForMode(mode: ListenScreenMode) -> CGFloat {
        let part = Double(mode.rawValue + 1) / Double(ListenScreenMode.allCases.count)
        let position = size.width
        let positionWithoutSpacings = position * part
        
        var result = positionWithoutSpacings + (Double(buttonHorizontalStackSpacing) * Double(mode.rawValue))
        
        if mode.rawValue == 0 {
            result += Double(10)
        }
        
        return result
    }
}


private struct ToggleViewStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(Animation.linear(duration: 0.2), value: configuration.isPressed)
            .imageScale(.large)
    }
}
