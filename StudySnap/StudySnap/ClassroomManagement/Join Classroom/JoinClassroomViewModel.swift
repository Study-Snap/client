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
    func joinUserClassroom(classId: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().joinClassroom(classIdData: classId) { res in
            if res.statusCode != 200 {
                // Received message
                print(res)
                self.error = true
                self.errorMessage = res.message
            }
            completion()
        }
    }
}
