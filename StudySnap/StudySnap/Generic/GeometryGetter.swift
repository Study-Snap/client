//
//  GeometryGetter.swift
//  StudySnap
//
// Retrieved from: https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui
//
//  Created by Ben Sykes on 2021-04-05.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
