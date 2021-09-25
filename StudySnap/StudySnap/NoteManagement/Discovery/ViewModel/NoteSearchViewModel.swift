//
//  NoteSearchViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

class NoteSearchViewModel: ObservableObject {
    @Published var trending: [ApiNoteResponse] = []
    @Published var results: [ApiNoteResponse] = []
    @Published var error: Bool = false
    @Published var errorMessage: String?
    
    func getTopTrendingNotes() -> Void {
        NeptuneApi().getTopNotesByRating() { res in
            if res[0].message != nil {
                // Failed (no results or other known error)
                self.trending = []
                self.error.toggle()
                self.errorMessage = res[0].message
            } else if res.count == 0 {
                // Failed (unknown error)
                self.trending = []
                self.error.toggle()
                self.errorMessage = "Failed to perform the search"
            } else {
                // Success
                self.trending = res
            }
        }
    }
    
    func search(searchQuery: String) -> Void {
        NeptuneApi().getNotesForQuery(query: searchQuery) { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
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
