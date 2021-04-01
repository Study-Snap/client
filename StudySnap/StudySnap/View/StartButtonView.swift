//
//  StartButtonView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-18.
//

import SwiftUI

struct StartButtonView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
    
            ZStack {//Rectangle 2
               
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .frame(width: 314, height: 70)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10000000149011612)), radius:40, x:0, y:20)
                
                
                Button(action: {
                    isOnboarding = false
                }, label: {
                    //Get started
                    Text("Get started").font(.custom("Raleway Bold", size: 20)).foregroundColor(Color(#colorLiteral(red: 0.15, green: 0.33, blue: 0.34, alpha: 1))).multilineTextAlignment(.center)
                })
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10000000149011612)), radius:40, x:0, y:20)

            }
        }
    
}
        
//        Button(action: {
//        }) {
//            HStack(spacing: 8) {
//                Text("Get Started")
//
//                Image(systemName: "arrow.right.circle")
//                    .imageScale(.large)
//            }
//            .padding(.horizontal, 50)
//            .padding(.vertical, 10)
//            .background(
//                Color.white
//            )
//        } //: BUTTON
//        .accentColor(Color("Secondary"))
//        .cornerRadius(20)
//    }

    


struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
            .preferredColorScheme(.light)
          .previewLayout(.sizeThatFits)
    }
}

