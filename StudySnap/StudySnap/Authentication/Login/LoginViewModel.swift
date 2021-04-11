//
//  LoginViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func performLogin(completion: @escaping (Bool, String?) -> Void) -> Void {
        AuthApi().login(email: email, password: password) {
            (res) in
            
            if res.message != nil {
                print("Failed to log in. Reason: \(res.message!)")
                
                // Complete with error
                completion(false, "Failed to log in. \(res.message!)")
            } else {
                if res.accessToken != nil && res.refreshToken != nil {
                    // Save access and refresh tokens
                    do {
                        try TokenService().addToken(token: Token(type: .accessToken, data: res.accessToken!))
                        try TokenService().addToken(token: Token(type: .refreshToken, data: res.refreshToken!))
                    } catch let error as TokenServiceError {
                        completion(false, error.message ?? "no message")
                    } catch {
                        completion(false, nil)
                    }
                    
                    // Complete successfully
                    completion(true, "Login Success")
                } else {
                    print("Something went wrong... Malformed response")
                    
                    // Complete with error
                    completion(false, "Login failed. Malformed response recieved.")
                }
            }
        }
    }
}
