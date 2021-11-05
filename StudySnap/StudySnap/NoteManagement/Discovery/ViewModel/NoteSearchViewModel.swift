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
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    
    func getTopTrendingNotes(currentClassId: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().getTopNotesByRating(classId: currentClassId) { res in
            if res[0].message != nil {
                // Failed (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.getTopTrendingNotes(currentClassId: currentClassId, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    print(res)
                    // Some error occurred (unkown)
                    self.trending = []
                    self.error = true
                    self.errorMessage = res[0].message
                }
            } else if res.count == 0 {
                // No notes found in the classroom (this is okay)
                self.trending = []
            } else {
                // Success
                self.trending = res
            }
        }
    }
    
    func search(searchQuery: String, currentClassId: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().getNotesForQuery(query: searchQuery, classId: currentClassId) { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    refreshAccessWithHandling { refreshed in
                        print("Refreshed: \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.search(searchQuery: searchQuery, currentClassId: currentClassId, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else {
                    // Another error occurred (is authorized, but something was wrong)
                    print(res)
                    self.results = []
                    self.error = true
                    self.errorMessage = res[0].message
                }
            } else if res.count == 0 {
                // No notes found for the query
                self.results = []
            } else {
                // Successful search
                self.results = res
            }
        }
    }
    
}
