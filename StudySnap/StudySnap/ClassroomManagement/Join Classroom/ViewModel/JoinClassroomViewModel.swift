//
//  JoinClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

class JoinClassroomViewModel: ObservableObject{
    @Published var error: Bool = false
    @Published var errorMessage: String? = ""
    @Published var classId: String = ""
    @Published var unauthorized: Bool = false
    
    func joinUserClassroom(classId: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().joinClassroom(classIdData: classId) { res in
            if res.statusCode != 200 {
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (joinUserClassroom): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        } else {
                            // If a new access token was generated, retry
                            self.joinUserClassroom(classId: classId, completion: completion)
                        }
                    }
                } else {
                    // Received message
                    self.error = true
                    self.errorMessage = res.message
                    completion()
                }
            } else{
                // Success
                completion()
            }
        }
    }
}
