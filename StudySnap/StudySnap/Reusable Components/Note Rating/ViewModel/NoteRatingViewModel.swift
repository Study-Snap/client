//
//  NoteRatingViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-11-21.
//

import SwiftUI

class NoteRatingViewModel: ObservableObject {
    @Published var results: [ApiNoteResponse] = []
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var ratingValue: Int = 1
    @Published var loading: Bool = true
    
    func putRating(ratingValue: Int, currentNoteId: Int, completion: @escaping () -> ()) -> Void {
        NeptuneApi().putNoteRating(value: ratingValue, noteId: currentNoteId){ res in
            if res[0].message != nil {
                // Failed search (no results or other known error)
                if res[0].message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (search): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.putRating(ratingValue: ratingValue, currentNoteId: currentNoteId, completion: completion)
                        } else {
                            completion()
                        }
                    }
                } else if res[0].message!.contains("Could not find") {
                    // No notes found (clear message)
                    self.results = []
                    self.loading = false
                } else {
                    // Another error occurred (is authorized, but something was wrong)
                    self.results = []
                    self.loading = false
                    self.error = true
                    self.errorMessage = res[0].message
                }
            } else if res.count == 0 {
                // No notes found for the query (with no message)
                
                self.results = []
                self.loading = false
            } else {
                // Successful search
                self.results = res
                self.loading = false
                completion()
            }
        }
    }
    
    func getAverageRating(currentNoteId: Int,completion: @escaping () -> ()) -> Void {
        NeptuneApi().getAverageNoteRating(noteId: currentNoteId) { res in
            if res.statusCode != 200 {
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (averageNoteRating): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if self.unauthorized {
                            completion()
                        } else {
                            // If a new access token was generated, retry
                            self.getAverageRating(currentNoteId: currentNoteId, completion: completion)
                        }
                    }
                } else {
                    // Received message
                    self.error = true
                    self.errorMessage = res.message
                    self.loading = false
                    completion()
                }
            } else{
                // Success
                self.ratingValue = res.value!
                self.loading = false
                completion()
                
            }
        }
    }
    
}
