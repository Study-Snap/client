//
//  MainView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

//var globalEventManager = GlobalString()
struct MainView: View {
    @Binding var rootIsActive : Bool
    
    var body: some View {
        
        
        TabView{
            ClassroomsDashboard(rootIsActive: self.$rootIsActive)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Classrooms")
                    
                }
            
            PersonalNotesView(rootIsActive: self.$rootIsActive)
                .tabItem {
                    Image(systemName: "note")
                    Text("My Notes")
                }
            
            ProfileView(rootIsActive: self.$rootIsActive)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .ignoresSafeArea()
        .accentColor(.primary)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(rootIsActive: .constant(true))
    }
}
