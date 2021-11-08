//
//  Styles.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-11-07.
//

import SwiftUI

struct StrokeStyle: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme //To accomidate for Dark mode
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

extension View{
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: 30.0))
    }
}

