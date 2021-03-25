//
//  RecommendationView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI
//import Lottie

struct RecommendationView: View {
    @AppStorage("isAnimated") var isAnimated: Bool = true
    var body: some View {
        //Text("This is the recommendation view")
        ZStack {
            VStack {
                Text("To be released in 2050")
                    .font(.largeTitle)
            }
        }
        
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}
/*
struct SplashScreen : View{
    var body: some View {
        VStack{
            AnimatedView()
        }
    }
}

struct AnimatedView: UIViewRepresentable{
    
    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: "splash3", bundle: Bundle.main)
        view.play()
        
        return view
    }
    func updateUIView(_ uiView: AnimationView, context: Context) {
        
    }
}
 */
