//
//  SignUpViewModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
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
    
    func performSignUp(completion: @escaping (Bool, String?) -> Void) -> Void {
        // Create a student object
        let student: Student = Student(firstName: firstName, lastName: lastName, email: email, password: password)
        
        // Register user in database
        AuthApi().register(student: student) {
            (user) in
            if user.message != nil {
                print("User was not created. Reason: \(user.message!)")
                completion(false, user.message) // False means did not sign up user
            } else if user.firstName != nil {
                print("User created successfully! Email: \(user.email!), Name: \(user.firstName!) \(user.lastName!)")
                completion(true, nil) // True means everything worked
            } else {
                completion(false, "Unknown error occurred")
            }
        }
    }
}
