//
//  SelectedShape.swift
//  Emoji Art
//
//  Created by zhira on 7/28/24.
//

import SwiftUI

struct SelectedShape: View {
    let enabled: Bool
    private let lineWidth: CGFloat = 4

    var body: some View {
        Capsule()
            .glow(
                enabled: enabled,
                fill: .palette,
                lineWidth: lineWidth
            )
    }
}

extension View where Self: Shape {
    func glow(
        enabled: Bool,
        fill: some ShapeStyle,
        lineWidth: Double,
        blurRadius: Double = 8.0,
        lineCap: CGLineCap = .round
    ) -> some View {
        stroke(
            style: StrokeStyle(
                lineWidth: lineWidth / 2,
                lineCap: lineCap
            )
        )
        .fill(fill)
        .overlay {
            self
                .stroke(
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: lineCap
                    )
                )
                .fill(fill)
                .blur(radius: blurRadius)
        }
        .opacity(enabled ? 1 : 0)
    }
}

extension ShapeStyle where Self == AngularGradient {
    static var palette: some ShapeStyle {
        .angularGradient(
            stops: [
                .init(color: .indigo, location: 0.0),
                .init(color: .blue, location: 0.4),
                .init(color: .indigo, location: 0.8),
                .init(color: .blue, location: 1.0),
            ],
            center: .center,
            startAngle: Angle(radians: .zero),
            endAngle: Angle(radians: .pi * 2)
        )
    }
}
