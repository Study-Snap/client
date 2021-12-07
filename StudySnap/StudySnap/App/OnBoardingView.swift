//
//  OnBoardingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-18.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    // Applicaiton (globals)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            ZStack {
                if (colorScheme == ColorScheme.light) {
                    Image("Background").resizable().ignoresSafeArea()
                } else {
                    Image("BackgroundDark").resizable().ignoresSafeArea()
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    Text("Study Snap").font(.largeTitle).fontWeight(.bold).foregroundColor(Color("AccentDark"))
                    if (colorScheme == ColorScheme.light) {
                        Image("LogoRound").resizable().scaledToFit().padding(.horizontal, 100).padding(.top, 25).padding()
                    } else {
                        Image("LogoRoundDark").resizable().scaledToFit().padding(.horizontal, 100).padding(.top, 25).padding()
                    }
                    Spacer()
                    StartButtonView().padding()
                
                }
            }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
            .preferredColorScheme(.light)
    }
}
