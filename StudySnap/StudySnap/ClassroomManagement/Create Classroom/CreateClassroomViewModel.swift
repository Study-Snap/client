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
    func postUserClassroom(className: String) -> Void {
        NeptuneApi().createClassroom(classNameData: className) { res in
            if res.message != nil {
                // Failed to find user
         
                self.error.toggle()
                self.errorMessage = res.message
            
            } else {
                // Successful search
                
                
            }
        }
    }
}
