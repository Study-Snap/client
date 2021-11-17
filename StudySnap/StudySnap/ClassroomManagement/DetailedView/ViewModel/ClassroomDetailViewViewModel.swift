//
//  NoteSearchViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

class ClassroomDetailViewViewModel: ObservableObject {
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
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (getTopTrendingNotes): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        } else {
                            // If a new access token was generated, retry
                            self.getTopTrendingNotes(currentClassId: currentClassId, completion: completion)
                        }
                    }
                } else if res[0].message!.contains("No notes were found") {
                    // No notes exist for classroom (no need for error message)
                    self.trending = []
                    completion()
                } else {
                    // Some error occurred (unkown)
                    self.trending = []
                    self.error = true
                    self.errorMessage = res[0].message
                    completion()
                }
            } else {
                // Success
                self.trending = res
                completion()
            }
        }
    }
    
    func search(searchQuery: String, currentClassId: String, completion: @escaping () -> ()) -> Void {
        NeptuneApi().getNotesForQuery(query: searchQuery, classId: currentClassId) { res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (search): \(refreshed)")
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
