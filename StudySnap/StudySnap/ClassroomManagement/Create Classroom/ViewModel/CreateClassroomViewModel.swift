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
    @Published var thumbnail: String = ""
    @Published var unauthorized: Bool = false
    
    func createClassroom(classCreateData: CreateClassroomData, completion: @escaping () -> ()) -> Void {
        print(classCreateData)
        NeptuneApi().createClassroom(data: classCreateData) { res in
            if res.message != nil || res.error != nil {
                // Error occurred... or something
                if res.message!.contains("Unauthorized") {
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (createClassroom): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        }
                        else {
                            // If a new access token was generated, retry note upload
                            self.createClassroom(classCreateData: classCreateData, completion: completion)
                        }
                    }
                } else {
                    // Another error occurred
                    self.error = true
                    self.errorMessage = res.message
                    completion()
                }
            } else {
                // Class create successful. Complete execution
                completion()
            }
        }
    }
}
