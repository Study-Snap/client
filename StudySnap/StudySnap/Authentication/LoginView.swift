//
//  LoginView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-03.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    // Field show
    @State var showPassword: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Text("Log In").font(.largeTitle).padding()
                }
                
                // Input fields
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter your email address", value: $email).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                
                if showPassword {
                    InputField(fieldHeight: 15, placeholder: "Password", value: $password).padding(.bottom, 10).padding(.horizontal, 17.5)
                } else {
                    SecureInputField(fieldHeight: 15, placeholder: "Password", value: $password).padding(.bottom, 10).padding(.horizontal, 17.5)
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
                
                Spacer()
                
                PrimaryButtonView(title: "Log In", action: {
                    // Log in user
                    AuthApi().login(email: email, password: password) {
                        (res) in
                        
                        if res.message != nil {
                            print("Failed to log in. Reason: \(res.message!)")
                        } else {
                            if res.accessToken != nil && res.refreshToken != nil {
                                print("Access Token: \(res.accessToken!) and Refresh Token: \(res.refreshToken!)")
                            } else {
                                print("Something went wrong... Malformed response")
                            }
                        }
                    }
                    
                    // Save access and refresh tokens
                    
                    // Failed to log in
                })
                
                // Button to create account
                NavigationLink(
                    destination: SignUpView(),
                    label: {
                        Text("No Account? Create one!").foregroundColor(Color("Secondary")).padding(.top, 5)
                })
            }
        }
        .padding(.all, 1)
        .padding(.top, -110)
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
