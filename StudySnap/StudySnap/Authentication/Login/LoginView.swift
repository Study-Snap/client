//
//  LoginView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-03.
//

import SwiftUI

struct LoginView: View {
    // View Model
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    
    // View event state
    @State var actionMainView: Bool = false
    @State var actionSignUpView: Bool = false
    @State var error: Bool = false
    @State var errorMessage: String?
    @State var showPassword: Bool = false
    @State var loggedIn: Bool = !TokenService().getToken(key: .accessToken).isEmpty
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Text("Log In").font(.largeTitle).padding()
                }
                
                // Input fields
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter your email address", value: $viewModel.email).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                
                if showPassword {
                    InputField(fieldHeight: 15, autoCap: false, placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
                } else {
                    SecureInputField(fieldHeight: 15, placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
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
                    if self.viewModel.email.isEmpty || self.viewModel.password.isEmpty {
                        // Validation error
                        self.error.toggle()
                        self.errorMessage = "Ensure to enter BOTH your email and password!"
                    } else {
                        self.viewModel.performLogin(completion: {
                            (success, message) in
                            
                            if success {
                                self.actionMainView.toggle() // Trigger move to MainView
                            } else {
                                self.error.toggle()
                                self.errorMessage = message
                            }
                        })
                    }
                })
                
                // Create new account
                Button(action: {
                    self.actionSignUpView.toggle()
                }) {
                    Text("No Account? Create one!").foregroundColor(Color("Secondary")).padding(.top, 5)
                }
                
                // Handle navigation logic
                NavigationLink(
                    destination: MainView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true),
                    isActive: $actionMainView
                ) {
                    EmptyView() // Button follows
                }
                NavigationLink(destination: SignUpView()
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                               , isActive: $actionSignUpView) {
                    EmptyView() // Supports: Sign in programatically
                }
                NavigationLink(destination: MainView()
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true), isActive: $loggedIn) {
                    EmptyView()
                }
            }.alert(isPresented: $error, content: {
                Alert(title: Text("Login Failed"), message: Text(self.errorMessage ?? "Unknown Reason"), dismissButton: Alert.Button.cancel(Text("Okay")))
            })
            
        }
        .padding(.all, 1)
        .padding(.top, -110)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LoginError {
    enum ErrorType {
        case badCredentials
        case service
        case keychain
        case userDoesNotExist
    }
    
    var type: ErrorType
    var message: String
}
