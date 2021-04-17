//
//  NoteViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-16.
//

import SwiftUI

class NoteViewViewModel: ObservableObject {
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var loading: Bool = true
    
    @Published var noteObj: ApiNoteResponse = ApiNoteResponse(id: 1, title: "Cool", keywords: ["not", "cool"], shortDescription: "Short description", body: "aiduhwaidu", fileUri: "", authorId: 1, rating: [2, 2, 2, 2, 2], timeLength: 5, isPublic: false, allowDownloads: false, bibtextCitation: "", statusCode: 200)
    
    func getNoteDetailsForId(id: Int) -> Void {
        NeptuneApi().getNoteWithId(noteId: id) { res in
            if res.message != nil {
                print(res.message!)
                self.loading.toggle()
                self.error.toggle()
                self.errorMessage = res.message
            } else {
                self.noteObj = res
                self.loading.toggle()
            }
        }
    }
    
}
