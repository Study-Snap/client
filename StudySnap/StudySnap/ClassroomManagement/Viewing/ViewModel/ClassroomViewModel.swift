//
//  ClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-30.
//

import SwiftUI

class ClassroomViewViewModel: ObservableObject {
    @Published var results: [ApiClassroomResponse] = []
    @Published var unauthorized: Bool = false
    @Published var currentUser: Int = 0
    @Published var classroomOwner: Int = 0
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var loading: Bool = true
    @Published var classId: String = ""
    
    func getClassroomsForUser(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserClassrooms() { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getClassroomsForUser(completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Another error occurred
                    self.results = []
                    self.loading = false
                    self.error = true
                    self.errorMessage = res[0].message
                }
            } else if res.count == 0 {
                // No Notes (empty)
                self.results = []
                self.loading = false
            } else {
                // Successful in loading classrooms
                self.results = res
                self.loading = false
            }
        }
    }
    
    /**
        @Sheharyaar
        These functions (getClassroom and getUser) *WILL* fail as soon as access token is revoked/expired since there is no refresh flow here... @Ben will look into this
     */
    func getUser() -> Void {
        NeptuneApi().getCurrentUserId(){ res in
            if res.message != nil {
                // Failed to find user
                self.error.toggle()
                self.errorMessage = res.message
            
            } else {
                // Successful get user
                self.currentUser = res.id!
                
            }
        }
    }
    func getClassroom(classId: String) -> Void {
        NeptuneApi().getCurrentClassroomOwner(classIdData: classId){ res in
            if res.message != nil {
                // Failed to find user
                self.error.toggle()
                self.errorMessage = res.message
                self.loading = false
            
            } else {
                // Successful search
                self.classroomOwner = res.ownerId!
                self.loading = false
                
            }
        }
    }
    func leaveClassroomResponse(classId: String, completion: @escaping () -> ()) -> Void{
        NeptuneApi().leaveClassroom(classIdData: classId) { res in
            if res.statusCode != 200 && res.message != nil {
                // Error occurred
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.leaveClassroomResponse(classId: classId, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Another error occurred
                    self.error = true
                    self.errorMessage = res.message
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}


