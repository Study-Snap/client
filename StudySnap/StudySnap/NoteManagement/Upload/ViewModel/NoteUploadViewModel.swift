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
    
    func validateNoteUpload(data: CreateNoteData) -> Bool {
        if data.title.isEmpty || data.shortDescription.isEmpty || data.keywords.isEmpty || data.fileName.isEmpty || data.fileData.isEmpty {
            if data.keywords.count > 5 || data.keywords.count < 2 {
                self.error.toggle()
                self.errorMessage = "Invalid Upload Request. Must include between 2 and 5 keywords"
                return false
            }
            if data.title.count > 50 {
                self.error.toggle()
                self.errorMessage = "Invalid Upload Request. Title must be less than 50 characters long"
                return false
            }
            if data.shortDescription.count > 280 {
                self.error.toggle()
                self.errorMessage = "Invalid Upload Request. Short description is too long! Must be under 280 characters"
                return false
            }
            if data.shortDescription.count < 60 {
                self.error.toggle()
                self.errorMessage = "Invalid Upload Request. Short description is somehow too short! Must be above 60 characters"
                return false
            }
            if data.fileName.components(separatedBy: ".").last != "pdf" {
                self.error.toggle()
                self.errorMessage = "Invalid Upload Request. Invalid file format. We currently only accept PDF files"
                return false
            }
            
            // All other errors
            self.error.toggle()
            self.errorMessage = "Invalid Upload Request. Check that all fields are filled in"
            return false
        }
        return true
    }
    
    func performUpload(noteData: CreateNoteData, completion: @escaping () -> ()) -> Void {
        if validateNoteUpload(data: noteData) {
            NeptuneApi().createNote(noteData: noteData) { res in
                if res.message != nil || res.error != nil {
                    // Error occurred... or something
                    if res.message!.contains("Unauthorized") {
                        AuthApi().refreshTokens() { tokens in
                            if tokens.message != nil && tokens.message != "success" {
                                print(tokens.message!)
                                self.error.toggle()
                                self.errorMessage = "Cannot refresh your session. You must login again."
                            } else {
                                do {
                                    // MARK: Refresh authentication if possible, else, send user back to login
                                    try TokenService().removeToken(key: .accessToken)
                                    try TokenService().removeToken(key: .refreshToken)
                                    try TokenService().addToken(token: Token(type: .accessToken, data: tokens.accessToken!))
                                    try TokenService().addToken(token: Token(type: .refreshToken, data: tokens.refreshToken!))
                                } catch {
                                    print(error.localizedDescription)
                                    self.error.toggle()
                                    self.errorMessage = "Cannot refresh your session. You must login again."
                                }
                                
                                // Call the function again to try again
                                self.performUpload(noteData: noteData, completion: completion)
                            }
                        }
                    } else {
                        self.error.toggle()
                        self.errorMessage = res.message
                    }
                } else {
                    // Return the response (containing the note)
                    self.response = res
                }
            }
        }
        
        completion()
    }
}
