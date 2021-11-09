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
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var response: ApiUserId?
    @Published var unauthorized: Bool = false
    
    
    func performLogout() -> Void {
        AuthApi().deauthenticate { (completed) in
            if !completed {
                self.error = true
                self.errorMessage = "Failed to deauthenticate."
            } else {
                self.authenticated = false
                self.logout = true
            }
        }
    }
    
    func getUserInformation(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getCurrentUserId() { res in
            if res.message != nil || res.error != nil {
                if res.message!.contains("Unauthorized") {
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        }
                        else {
                            self.getUserInformation(completion: completion)
                        }
                    }
                    completion()
                } else {
                    self.error = true
                    self.errorMessage = res.message
                    completion()
                }
            } else {
                self.response = res
                completion()
            }
        }
    }
}
