//
//  ProfileViewViewModel.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-10-11.
//

import SwiftUI

class ProfileViewViewModel: ObservableObject {
    // View properties
    @Published var authenticated: Bool = true
    @Published var logout: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var unauthorized: Bool = false
    
    // User Data
    @Published var userDataResponse: ApiUserId?
    @Published var userClassroomCount: Int?
    @Published var userNotesCount: Int?
    @Published var userTotalContentMinutes: Int?
    
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
    
    func getClassroomsCount(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserClassrooms() { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getClassroomsCount): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getClassroomsCount(completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Another error occurred
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                // Successful in loading classrooms
                self.userClassroomCount = res.count
                completion()
            }
        }
    }
    
    func getTotalNotesByUser(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserNotes() { res in
            if res[0].message != nil {
                // Failed (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getTotalNotesByUser): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getTotalNotesByUser(completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Some error occurred (unkown)
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                // Success
                self.userNotesCount = res.count
                completion()
            }
        }
    }
    
    func getTotalContentMinutes(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserNotes() { res in
            if res[0].message != nil {
                // Failed (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getTotalContentMinutes): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getTotalContentMinutes(completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Some error occurred (unkown)
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                // Success
                var minutes = 0
                for note in res {
                    minutes += note.timeLength!
                }
                self.userTotalContentMinutes = minutes
                completion()
            }
        }
    }
    
    func getUserInformation(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getCurrentUserId() { res in
            if res.message != nil || res.error != nil {
                if res.message!.contains("Unauthorized") {
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getUserInformation): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        }
                        else {
                            self.getUserInformation(completion: completion)
                        }
                    }
                } else {
                    self.error = true
                    self.errorMessage = res.message
                    completion()
                }
            } else {
                self.userDataResponse = res
                completion()
            }
        }
    }
}
