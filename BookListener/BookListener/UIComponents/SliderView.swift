//
//  SliderView.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Combine
import SwiftUI

// MARK: - SliderView

public struct SliderView: View {
    @State private var offset: CGFloat = 0
    @State private var isDragging: Bool = false

    let valuePublisher: AnyPublisher<Double, Never>
    @State private var value: Double = 0.0

    let leftLabelValuePublisher: AnyPublisher<String, Never>
    @State private var leftLabelValue: String = "0.0"

    let rightLabelValuePublisher: AnyPublisher<String, Never>
    @State private var rightLabelValue: String = "0.0"

    private let title: String?
    private let systemImage: String
    let sliderWidth: CGFloat
    private let sliderHeight: CGFloat
    private let sliderColor: Color

    private let changeSubject: any Subject<Double, Never>
    private let onChangeEnd: ((Double) -> Void)?

    public init(
        _ title: String? = nil,
        systemImage: String = "",
        sliderWidth: CGFloat = 250,
        sliderHeight: CGFloat = 10,
        sliderColor: Color? = nil,
        valuePublisher: AnyPublisher<Double, Never>,
        leftLabelValuePublisher: AnyPublisher<String, Never>,
        rightLabelValuePublisher: AnyPublisher<String, Never>,
        changeSubject: any Subject<Double, Never>,
        onChangeEnd: ((Double) -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        self.sliderColor = sliderColor ?? .accentBlue
        self.valuePublisher = valuePublisher
        self.leftLabelValuePublisher = leftLabelValuePublisher
        self.rightLabelValuePublisher = rightLabelValuePublisher
        self.onChangeEnd = onChangeEnd
        self.changeSubject = changeSubject
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
        }.onAppear()
            .onReceive(valuePublisher) { value in
                self.value = value
            }
            .onReceive(leftLabelValuePublisher) { value in
                leftLabelValue = value
            }
            .onReceive(rightLabelValuePublisher) { value in
                rightLabelValue = value
            }
    }

    private func updateValue() {
        value = Double(offset / (sliderWidth - sliderHeight)) * 100
        changeSubject.send(value)
    }

    private func updateOffset(to value: Double) {
        let newOffset = (value / 100.0) * (sliderWidth - sliderHeight)
        offset = max(0, min(newOffset, sliderWidth - sliderHeight))
    }
}

// MARK: - SliderViewBase

private struct SliderViewBase: View {
    @Binding var offset: CGFloat
    @Binding var isDragging: Bool

    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    let sliderColor: Color
    let systemImage: String
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
