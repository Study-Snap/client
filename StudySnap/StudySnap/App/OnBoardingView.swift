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
       
            ZStack {
                    //image 1
                    Image("LandingPageBkg")
                        .resizable()
                        .ignoresSafeArea(.all)
        

                    VStack(alignment: .center) {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .padding(50)
                        Spacer()
                        Spacer()
                            
                    
                        StartButtonView().padding()
                    
                    }

                }
      
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
