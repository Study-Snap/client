//
//  JoinClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

class JoinClassroomViewModel: ObservableObject{
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var classId: String = ""
    func joinUserClassroom(classId: String) -> Void {
        NeptuneApi().joinClassroom(classIdData: classId) { res in
            if res.message != nil {
                // Received message
                self.error.toggle()
                self.errorMessage = res.message
            
            } else{
                // Failed to receive message
                self.errorMessage = res.message
            }
        }
    }
}
