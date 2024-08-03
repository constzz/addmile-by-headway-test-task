//
//  SliderView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import SwiftUI
import Combine

public struct SliderView: View {
        
    @Environment(\.colorScheme) private var colorScheme

    @State private var offset: CGFloat = 0
    @State private var isDragging: Bool = false

    @Binding private var value: Double

    private let title: String?
    private let systemImage: String
    private let sliderWidth: CGFloat
    private let sliderHeight: CGFloat
    private let sliderColor: Color
    @Binding private var leftLabelValue: String
    @Binding private var rightLabelValue: String
    private let onChange: ((Double) -> Void)?
    private let onChangeEnd: ((Double) -> Void)?

    public init(
        _ title: String? = nil,
        systemImage: String = "",
        sliderWidth: CGFloat = 250,
        sliderHeight: CGFloat = 10,
        sliderColor: Color? = nil,
        value: Binding<Double>,
        leftLabelValue: Binding<String>,
        rightLabelValue: Binding<String>,
        onChange: ((Double) -> Void)? = nil,
        onChangeEnd: ((Double) -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderColor = sliderColor ?? .accentBlue
        self._value = value
        self._leftLabelValue = leftLabelValue
        self._rightLabelValue = rightLabelValue
        self.onChange = onChange
        self.onChangeEnd = onChangeEnd
    }

    private var halfThumbSize: CGFloat {
        sliderHeight / 2
    }

    private var sliderFillWidth: CGFloat {
        let fillAmount = min(offset + halfThumbSize, sliderWidth - halfThumbSize)
        return max(halfThumbSize, fillAmount) + halfThumbSize
    }

    public var body: some View {
        HStack {
            Text(leftLabelValue)
                .fixedSize(horizontal: true, vertical: false)
            VStack(alignment: .leading) {
                if let title {
                    Text(title)
                        .foregroundStyle(Color.primary)
                        .font(.system(size: halfThumbSize))
                }

                SliderViewBase(
                    offset: $offset,
                    isDragging: $isDragging,
                    sliderWidth: sliderWidth,
                    sliderHeight: sliderHeight,
                    sliderColor: sliderColor,
                    systemImage: systemImage,
                    colorScheme: colorScheme,
                    onChange: updateValue,
                    onChangeEnd: { onChangeEnd?(value) }
                )
            }
            .padding(12)
            .onChange(of: value) { newValue in
                updateOffset(to: newValue)
            }
            .onAppear {
                updateOffset(to: value)
            }
            Text(rightLabelValue)
                .fixedSize(horizontal: true, vertical: false)
        }.onAppear {
            onChange?(value)
        }
    }

    private func updateValue() {
        value = Double(offset / (sliderWidth - sliderHeight)) * 100
        onChange?(value)
    }

    private func updateOffset(to value: Double) {
        let newOffset = (value / 100.0) * (sliderWidth - sliderHeight)
        offset = max(0, min(newOffset, sliderWidth - sliderHeight))
    }
}

private struct SliderViewBase: View {
    @Binding var offset: CGFloat
    @Binding var isDragging: Bool

    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    let sliderColor: Color
    let systemImage: String
    let colorScheme: ColorScheme
    let onChange: () -> Void
    let onChangeEnd: () -> Void

    private var halfThumbSize: CGFloat {
        sliderHeight / 2
    }

    private var sliderFillWidth: CGFloat {
        let fillAmount = min(offset + halfThumbSize, sliderWidth - halfThumbSize)
        return max(halfThumbSize, fillAmount) + halfThumbSize
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true
                updateOffset(at: value.location.x)
                onChange()
            }
            .onEnded { _ in
                isDragging = false
                onChangeEnd()
            }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            sliderTrack
            sliderFill
            sliderThumb
        }
        .gesture(dragGesture)
        .animation(.easeIn(duration: 0.1), value: offset)
    }

    private var sliderTrack: some View {
        Capsule()
            .fill(.darkBiege)
            .frame(width: sliderWidth, height: sliderHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var sliderFill: some View {
        Capsule()
            .fill(sliderColor)
            .frame(width: sliderFillWidth, height: sliderHeight)
    }
    
    private var sliderThumb: some View {
        Circle()
            .frame(width: sliderHeight * 2.5, height: sliderHeight * 2.5)
            .foregroundStyle(sliderColor)
            .brightness(isDragging ? -0.1 : 0)
            .overlay {
                Image(systemName: systemImage)
                    .font(.system(size: halfThumbSize))
                    .foregroundStyle(.accentBlue)
            }
            .offset(x: offset)
    }

    private func updateOffset(at location: CGFloat) {
        let adjustedLocation = location - halfThumbSize
        offset = max(0, min(adjustedLocation, sliderWidth - sliderHeight))
    }
}

