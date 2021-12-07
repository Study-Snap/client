//
//  StartButtonView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-18.
//

import SwiftUI

struct StartButtonView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    // Application (globals)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
    
            ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color("Accent"))
                    .frame(width: 314, height: 70)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10000000149011612)), radius:7, x:0, y:20)

                Button(action: {
                    isOnboarding = false
                }, label: {
                    Text("Get started").font(.custom("Raleway Bold", size: 20)).foregroundColor(Color("AccentReversed")).multilineTextAlignment(.center)
                })
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10000000149011612)), radius:40, x:0, y:20)

            }
        }
    
}


struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
            .preferredColorScheme(.light)
          .previewLayout(.sizeThatFits)
    }
}

