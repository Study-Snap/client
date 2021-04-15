//
//  MainView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
                TabView{
                    NoteSearchView()
                      .tabItem {
                        Image(systemName: "magnifyingglass.circle")
                        Text("Search")
                        
                      }
                    
                    StorageView()
                      .tabItem {
                        Image(systemName: "photo.on.rectangle")
                        Text("Storage")
                      }
                    
                    RecommendationView()
                      .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                      }
                    
                }
                .accentColor(Color("Primary"))
                .ignoresSafeArea()
              
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()      
    }
}
