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


