//
//  ChangePasswordViewModel.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-11-22.
//

import SwiftUI

class ChangePasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var newPassword: String = ""
    @Published var unauthorized: Bool = false
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    @Published var changePasswordSuccess: Bool = false
    
    func changePassword(completion: @escaping () -> Void) -> Void {
        AuthApi().changePassword(password: password, newPassword: newPassword) {
            (res) in
            
            if res.message != nil {
                // Failed (no results or other known error)
                if res.message!.contains("Unauthorized") {
                    // Authentication error
                    AuthApi().refreshAccessWithHandling { refreshed in
                        self.unauthorized = !refreshed
                        print("Refreshed (changePassword): \(refreshed)")

                        if self.unauthorized {
                            completion()
                        } else {
                            // If a new access token was generated, retry
                            self.changePassword(completion: completion)
                        }
                    }
                } else {
                    // Some error occurred (unknown)
                    self.error = true
                    self.errorMessage = res.message!
                    completion()
                }
            } else {
                // Success
                self.changePasswordSuccess = true
                completion()
            }
        }
    }
}
