//
//  PersonalNotesViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-11-17.
//

import SwiftUI

class PersonalNotesViewModel: ObservableObject{
    @Published var results: [ApiNoteResponse] = []
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    
    func getPersonalUserNotes(completion: @escaping () -> ()) -> Void {
        NeptuneApi().getUserNotes() { res in
            if res[0].message != nil {
                // Failed (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getPersonalUserNotes(completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else if res[0].message!.contains("No notes were found") {
                    // No notes exist for classroom (no need for error message)
                    self.results = []
                } else {
                    // Some error occurred (unkown)
                    self.results = []
                    self.error = true
                    self.errorMessage = res[0].message
                }
            } else {
                // Success
                self.results = res
            }
        }
    }
    
    func deleteUserNote(userNoteId: Int, completion: @escaping () -> ()) -> Void {
        NeptuneApi().deleteNote(noteId: userNoteId) { res in
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
                            self.deleteUserNote(userNoteId: userNoteId, completion: completion)
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
