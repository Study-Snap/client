//
//  DeleteClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-10-10.
//

import SwiftUI

class DeleteClassroomViewModel: ObservableObject{
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var classId: String = ""
    @Published var classroomOwner: Int = 0
    @Published var currentUser: Int = 0
    @Published var loading: Bool = true
    
    func deleteCurrentClassroom(classId: String) -> Void {
        NeptuneApi().deleteClassroom(classIdData: classId) { res in
            if res.message != nil {
                // Failed to find user
                self.loading = false
                self.error.toggle()
                self.errorMessage = res.message
            
            } else {
                // Successful search
                self.loading = false
                print("Classroom sucessfully deleted")
            }
        }
    }
    
    func getUser() -> Void {
        NeptuneApi().getCurrentUserId(){ res in
            if res.message != nil {
                // Failed to find user
                self.error.toggle()
                self.errorMessage = res.message
            
            } else {
                // Successful search
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
    func confirmClassroomDelete(classId: String) -> Void{
        getUser()
        getClassroom(classId: classId)
        self.loading = true
        if self.currentUser == self.classroomOwner{
            deleteCurrentClassroom(classId: classId)
        }
        else{
            self.error = true
            self.errorMessage = "You are not the class owner and idk how u even got to this error"
        }
    }
}
