//
//  StudySnapApp.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI

@main
struct StudySnapApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    let loggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnBoardingView()
            } else {
                // Check logged in
                if !loggedIn {
                    // Not logged in
                    LoginView()
                } else {
                    // If Logged in
                    MainView()
                }
            }
        }
    }
}
