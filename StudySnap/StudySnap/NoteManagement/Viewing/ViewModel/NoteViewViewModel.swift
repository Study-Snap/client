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
    @Published var title: String?
    @Published var description: String?
    @Published var loading: Bool = true
    
    func getNoteDetailsForId(id: Int) -> Void {
        NeptuneApi().getNoteWithId(noteId: id) { res in
            if res.message != nil {
                self.error.toggle()
                self.errorMessage = res.message
            } else {
                self.title = res.title
                self.description = res.shortDescription
                self.loading.toggle()
            }
        }
    }
    
}
