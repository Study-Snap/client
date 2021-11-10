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
    @Published var userClassroomResponse: [ApiClassroomResponse]?
    @Published var userNoteResponse: [ApiNoteResponse]?
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
    
    func getUserClassrooms(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserClassrooms() { res in
            if res[0].message != nil || res[0].error != nil {
                if res[0].message!.contains("Unauthorized") {
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        }
                        else {
                            self.getUserClassrooms(completion: completion)
                        }
                    }
                    completion()
                } else {
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                self.userClassroomResponse = res
                completion()
            }
        }
    }
    
    func getUserNotes(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserNotes() { res in
            if res[0].message != nil || res[0].error != nil {
                if res[0].message!.contains("Unauthorized") {
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        }
                        else {
                            self.getUserNotes(completion: completion)
                        }
                    }
                    completion()
                } else {
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                self.userNoteResponse = res
                completion()
            }
        }
    }
}
