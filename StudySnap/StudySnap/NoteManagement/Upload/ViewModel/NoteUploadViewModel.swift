//
//  NoteUploadViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-16.
//

import SwiftUI

class NoteUploadViewModel: ObservableObject {
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var response: ApiNoteResponse? = nil
    
    func performUpload(noteData: CreateNoteData) -> Void {
        NeptuneApi().createNote(noteData: noteData) { res in
            if res.message != nil {
                // Error occurred... or something
                self.error.toggle()
                self.errorMessage = res.message
            } else {
                // Return the response (containing the note)
                self.response = res
            }
        }
    }
}
