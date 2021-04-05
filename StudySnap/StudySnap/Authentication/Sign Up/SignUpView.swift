//
//  SignUpView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI


var viewModelGlobal = SignUpViewModel()
struct SignUpView: View {
    @StateObject var viewModel = viewModelGlobal
    
    var body: some View {
        SignUpMain(viewModel: viewModel)
    }
}

struct SignUpMain: View {
    @StateObject var viewModel = viewModelGlobal
    
    var body: some View {
        ZStack {
            NavigationView {
                // Main content
                SignUpContent(viewModel: viewModel)
                
                // Handle navigation to LoginView
                NavigationLink(
                    destination: LoginView(),
                    isActive: $viewModel.action
                ) {
                    EmptyView() // Button follows
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SignUpContent: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = viewModelGlobal
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Sign Up").font(.largeTitle).padding()
            }
            InputField(fieldHeight: 15, placeholder: "First Name", value: $viewModel.firstName).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,placeholder: "Last Name", value: $viewModel.lastName).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,textStyle: .emailAddress, autoCap: false, placeholder: "Email", value: $viewModel.email).padding(.bottom, 10).padding(.horizontal, 17.5)
            
            if !viewModel.showPassword {
                SecureInputField(fieldHeight: 15,placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
            } else {
                InputField(fieldHeight: 15,placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
            }
            
            Button(action: {viewModel.showPassword.toggle()}, label: {
                HStack {
                    Spacer()
                    if !viewModel.showPassword {
                        Text("Show Password").padding(.top, -10).padding(.trailing, 20).foregroundColor(Color("Secondary"))
                    } else {
                        Text("Hide Password").padding(.top, -10).padding(.trailing, 20).foregroundColor(Color("Secondary"))
                    }
                }
            })
            SecureInputField(fieldHeight: 15,placeholder: "Password Again", value: $viewModel.passwordCheck).padding(.bottom, 10).padding(.horizontal, 17.5).padding(.top, 15)
            Spacer()
            
            PrimaryButtonView(title: "Sign Up", action: {
                if viewModel.password.count > 0 && viewModel.password == viewModel.passwordCheck && viewModel.firstName.count > 0 && viewModel.lastName.count > 0 && viewModel.email.count > 0 {
                    // Validation passes, Sign up user
                    AuthApi().register(firstName: viewModel.firstName, lastName: viewModel.lastName, email: viewModel.email, password: viewModel.password) {
                        (user) in
                        if user.message != nil {
                            print("User was not created. Reason: \(user.message!)")
                        } else if user.firstName != nil {
                            print("User created successfully! Email: \(user.email!), Name: \(user.firstName!) \(user.lastName!)")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    // Validation failed
                    self.viewModel.error.toggle()
                    self.viewModel.errorMessage = ""
                }
            })
            
            Button(action: {
                self.viewModel.action.toggle()
            }) {
                ZStack {
                    Text("Already have an account? Login").font(.custom("Inter Semi Bold", size: 16)).foregroundColor(Color("Secondary")).multilineTextAlignment(.center)
                }.padding()
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
