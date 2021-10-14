//
//  MainView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

var globalEventManager = GlobalString()
struct MainView: View {
    @Binding var rootIsActive : Bool
    
    var body: some View {
        ZStack {
            TabView{
                ClassroomsView(rootIsActive: self.$rootIsActive)
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Classrooms")
                        
                    }
                
                StorageView()
                    .tabItem {
                        Image(systemName: "photo.on.rectangle")
                        Text("Storage")
                    }
                    
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
            .accentColor(Color("Primary"))
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.edgesIgnoringSafeArea([.top,.bottom])
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(rootIsActive: .constant(true))
    }
}
