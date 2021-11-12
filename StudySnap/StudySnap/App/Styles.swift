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
            RoundedRectangle(cornerRadius: 12, style: .continuous)
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
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}


extension View{
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: 30.0))
    }
    
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

