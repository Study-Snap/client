//
//  SearchPageView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-18.
//

import SwiftUI

struct SearchPageView: View {
    var body: some View {
        TabView{
          
            StartButtonView()
              .tabItem {
                Image(systemName: "play.rectangle")
                Text("Watch")
              }
            OnBoardingView()
              .tabItem {
                Image(systemName: "play.rectangle")
                Text("Watch")
              }
            ContentView()
              .tabItem {
                Image(systemName: "play.rectangle")
                Text("Watch")
              }

        }
    }
}

struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
