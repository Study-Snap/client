//
//  SignUpView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI

struct SignUpView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordCheck: String = ""
    @State var showPassword: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Sign Up").font(.largeTitle).padding()
            }
            InputField(fieldHeight: 15, placeholder: "First Name", value: $firstName).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,placeholder: "Last Name", value: $lastName).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,textStyle: .emailAddress, autoCap: false, placeholder: "Email", value: $email).padding(.bottom, 10).padding(.horizontal, 17.5)
            
            if !showPassword {
                SecureInputField(fieldHeight: 15,placeholder: "Password", value: $password).padding(.bottom, 10).padding(.horizontal, 17.5)
            } else {
                InputField(fieldHeight: 15,placeholder: "Password", value: $password).padding(.bottom, 10).padding(.horizontal, 17.5)
            }
            
            Button(action: {showPassword.toggle()}, label: {
                HStack {
                    Spacer()
                    if !showPassword {
                        Text("Show Password").padding(.top, -10).padding(.trailing, 20).foregroundColor(Color("Secondary"))
                    } else {
                        Text("Hide Password").padding(.top, -10).padding(.trailing, 20).foregroundColor(Color("Secondary"))
                    }
                }
            })
            SecureInputField(fieldHeight: 15,placeholder: "Password Again", value: $passwordCheck).padding(.bottom, 10).padding(.horizontal, 17.5).padding(.top, 15)
            Spacer()
            
            PrimaryButtonView(title: "Sign Up", action: {
                if password.count > 0 && password == passwordCheck && firstName.count > 0 && lastName.count > 0 && email.count > 0 {
                    // Validation passes, Sign up user
                    AuthApi().register(firstName: firstName, lastName: lastName, email: email, password: password) {
                        (user) in
                        if user.message != nil {
                            print("User was not created. Reason: \(user.message!)")
                        } else if user.firstName != nil {
                            print("User created successfully! Email: \(user.email!), Name: \(user.firstName!) \(user.lastName!)")
                        }
                    }
                } else {
                    // Validation failed
                }
            })
            NavigationLink(
                destination: LoginView(),
                label: {
                    ZStack {
                        Text("Already have an account? Login").font(.custom("Inter Semi Bold", size: 16)).foregroundColor(Color("Secondary")).multilineTextAlignment(.center)
                    }.padding()
                })
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
