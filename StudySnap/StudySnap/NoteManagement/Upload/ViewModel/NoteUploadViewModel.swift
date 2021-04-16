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
        if data.title.isEmpty || data.shortDescription.isEmpty || data.keywords.isEmpty || data.keywords.count < 2 || data.fileName.isEmpty || data.fileData.isEmpty {
            self.error.toggle()
            self.errorMessage = "Invalid Upload Request. Check that all fields are filled correctly then try again!"
            return false
        }
        return true
    }
    
    func performUpload(noteData: CreateNoteData) -> Void {
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
                                self.performUpload(noteData: noteData)
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
    }
}
