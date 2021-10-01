//
//  MainView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

var globalEventManager = GlobalString()
struct MainView: View {
    var body: some View {
        
                TabView{
                    ClassroomsView()
                      .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Classrooms")
                        
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
