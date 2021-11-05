//
//  CreateClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

class CreateClassroomViewModel: ObservableObject{
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var name: String = ""
    @Published var unauthorized: Bool = false
    
    func postUserClassroom(className: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().createClassroom(classNameData: className) { res in
            if res.message != nil {
                // Failed (no results or other known error)
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.postUserClassroom(className: className, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Other Error
                    self.error.toggle()
                    self.errorMessage = res.message
                }
            } else {
                // No problems Mr. Sheharyaar
                completion()
            }
        }
    }
}
