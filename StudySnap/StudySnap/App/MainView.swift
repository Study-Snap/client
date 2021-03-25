//
//  MainView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isAnimated") var isAnimated: Bool?
    var body: some View {
        TabView{
            ContentView()
              .tabItem {
                Image(systemName: "magnifyingglass.circle")
                Text("Search")
                
              }
            
            StorageView()
              .tabItem {
                Image(systemName: "map")
                Text("Storage")
              }
            
            RecommendationView()
              .tabItem {
                Image(systemName: "photo")
                Text("Recommendation")
              }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
