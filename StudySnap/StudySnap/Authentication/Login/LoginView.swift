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
    @State var actionMainView: Bool = false //???
    @State var actionSignUpView: Bool = false
    @State var error: Bool = false
    @State var errorMessage: String?
    @State var showPassword: Bool = false
    @State var loggedIn: Bool = !TokenService().getToken(key: .accessToken).isEmpty
    
    // Applicaiton (globals)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !self.loggedIn {
            NavigationView {
                VStack(alignment: .center) {
                    if (colorScheme == ColorScheme.light) {
                        Image("LogoRound").resizable().scaledToFit().padding(.horizontal, 100).padding(.top, 25).padding()
                    } else {
                        Image("LogoRoundDark").resizable().scaledToFit().padding(.horizontal, 100).padding(.top, 25).padding()
                    }
                    Text("StudySnap").font(.title).foregroundColor(Color("Secondary"))
                    
                    // Input fields
                    InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter your email address", value: $viewModel.email).padding(.top, 30).padding(.bottom, 10).padding(.horizontal, 17.5)
                    
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
                                    //self.actionMainView = true
                                    self.loggedIn = true// Trigger move to MainView
                                } else {
                                    self.error.toggle()
                                    self.errorMessage = message
                                }
                            })
                        }
                    }).padding(.horizontal)
                    
                    // Create new account
                    Button(action: {
                        self.actionSignUpView.toggle()
                    }) {
                        Text("No Account? Create one!").foregroundColor(Color("Secondary")).padding(.top, 5)
                    }
                    
                    NavigationLink(destination: SignUpView()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                   , isActive: $actionSignUpView) {
                        EmptyView() // Supports: Sign in programatically
                    }
                    
                }.navigationBarHidden(true)
                    .alert(isPresented: $error, content: {
                        Alert(title: Text("Login Failed"), message: Text(self.errorMessage ?? "Unknown Reason"), dismissButton: Alert.Button.cancel(Text("Okay")))
                    })
                
            }
            .padding(.all, 1)
        }else{
            MainView(rootIsActive: self.$loggedIn)
            
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
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
