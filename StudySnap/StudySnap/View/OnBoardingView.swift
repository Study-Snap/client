//
//  OnBoardingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-18.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        NavigationView{
            ZStack {
                    //image 1
                    Image(uiImage: #imageLiteral(resourceName: "LandingPageBkg"))
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all)

                    VStack(alignment: .center) {
                        
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 30)
                            .padding(.vertical, 110)
                            
                        Spacer()
                        Spacer()
                        StartButtonView()
                        Spacer()
                    }

                }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
