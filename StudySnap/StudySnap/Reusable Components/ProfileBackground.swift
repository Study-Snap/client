//
//  ProfileBackground.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-12-06.
//

import SwiftUI

struct ProfileBackground: View {
    var body: some View {
        Canvas { context, size in
            context.fill(Path(ellipseIn: CGRect(x: 20, y: 30, width: 100, height: 100)), with: .color(Color("Primary")))
            context.draw(Image(systemName: "hexagon.fill"), in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        .frame(width: 200, height: 212)
        .foregroundStyle(.linearGradient(colors: [Color("Primary"), Color("Secondary")], startPoint: .topLeading, endPoint: .bottomTrailing))
        
    }
}

struct ProfileBackground_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBackground()
    }
}
