//
//  SignUpViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    // Navigation
    @Published var action: Bool = true
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String?
    
    // Fields
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var showPassword: Bool = false
}
