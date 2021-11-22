//
//  NoteRatingViewModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-11-21.
//

import SwiftUI

class NoteRatingViewModel: ObservableObject {
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String?
    @Published var ratingValue: Int = 1
    @Published var loading: Bool = true
    
    func putRating(ratingValue: Int, currentNoteId: Int, completion: @escaping () -> ()) -> Void {
        NeptuneApi().putNoteRating(value: ratingValue, noteId: currentNoteId) { res in
            if res.message != nil {
                // Failed rating (check reason)
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        print("Refreshed (putRating): \(refreshed)")
                        self.unauthorized = !refreshed
                        
                        if !self.unauthorized {
                            // If a new access token was generated, retry
                            self.putRating(ratingValue: ratingValue, currentNoteId: currentNoteId, completion: completion)
                        } else {
                            // Unauthorized
                            self.loading = false
                            completion()
                        }
                    }
                } else {
                    // Unknown Error
                    self.loading = false
                    self.error = true
                    self.errorMessage = "Error occurred when rating the note. Reason: \(res.message!)"
                    completion()
                }
            } else {
                // Success
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
                        print("Refreshed (getAverageRating): \(refreshed)")
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
