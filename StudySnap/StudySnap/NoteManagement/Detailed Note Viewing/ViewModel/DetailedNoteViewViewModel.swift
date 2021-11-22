//
//  NoteViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-16.
//

import SwiftUI

class DetailedNoteViewViewModel: ObservableObject {
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var loading: Bool = true
    @Published var pdfFile: Data?
    
    // With default value the note object
    @Published var noteObj: ApiNoteResponse = ApiNoteResponse(id: 1, title: "Cool", classId: "8834jjr9js9", keywords: ["not", "cool"], shortDescription: "Short description", noteAbstract: "This is a default note abstract", fileUri: "", authorId: 1, timeLength: 5, bibtextCitation: "", user: UserModel(id: 1, email: "test@exampe.com", firstName: "Ftester", lastName: "Ltester"), statusCode: 200)
    
    func getNoteDetailsForId(id: Int, completion: @escaping () -> ()) -> Void {
        NeptuneApi().getNoteWithId(noteId: id) { res in
            if res.message != nil {
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getNoteDetailsForId): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry note upload
                            self.getNoteDetailsForId(id: id, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Another error occurred
                    self.loading = false
                    self.error = true
                    self.errorMessage = res.message
                }
            } else {
                self.noteObj = res
                self.loading = false
            }
            completion()
        }
    }
    
    func getNoteFileFromCDN(fileId: String, completion: @escaping () -> ()) -> Void {
        Spaces().getNoteDataFromCDN(fileId: fileId) { data in
            if data == nil {
                // Error getting note file data
                self.error = true
                self.errorMessage = "Failed to get note data from server"
            } else {
                self.pdfFile = data
            }
            completion()
        }
    }
    
}
