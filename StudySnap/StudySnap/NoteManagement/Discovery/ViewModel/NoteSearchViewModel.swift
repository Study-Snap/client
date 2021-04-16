//
//  NoteSearchViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

class NoteSearchViewModel: ObservableObject {
    @Published var results: [ApiNoteResponse] = []
    @Published var error: Bool = false
    @Published var errorMessage: String?
    
    func search(searchQuery: String) -> Void {
        NeptuneApi().getNotesForQuery(query: searchQuery) { res in
            if res[0].message != nil {
                // Failed search (no results)
                self.results = []
                self.error.toggle()
                self.errorMessage = res[0].message
            } else if res.count == 0 {
                // Failed (error)
                self.results = []
                self.error.toggle()
                self.errorMessage = "Failed to perform the search"
            } else {
                // Successful search
                self.results = res
            }
        }
    }
}
