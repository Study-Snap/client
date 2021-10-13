//
//  ProfileViewViewModel.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-10-11.
//

import SwiftUI

class ProfileViewViewModel: ObservableObject {
    
    @Published var authenticated: Bool = true
    @Published var logout: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    func performLogout() -> Void {
        AuthApi().deauthenticate { (completed) in
            if !completed {
                self.showError = true
                self.errorMessage = "Failed to deauthenticate."
            } else {
                self.authenticated = false
                self.logout = true
            }
        }
    }
}
