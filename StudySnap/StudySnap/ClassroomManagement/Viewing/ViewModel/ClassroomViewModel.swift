//
//  ClassroomViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-30.
//

import SwiftUI

class ClassroomViewViewModel: ObservableObject {
    @Published var results: [ApiClassroomsResponse] = []
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var loading: Bool = true
    
    func getClassroomsForUser() -> Void {
        NeptuneApi().getUserClassrooms() { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                self.results = []
                self.loading = false
                self.error.toggle()
                self.errorMessage = res[0].message
            } else if res.count == 0 {
                // Failed (error)
                self.results = []
                self.loading = false
            } else {
                // Successful in loading classrooms
                self.results = res
                self.loading = false
            }
        }
    }
}
