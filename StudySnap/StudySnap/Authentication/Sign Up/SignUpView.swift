//
//  SignUpView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI
import Combine

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        SignUpMain(viewModel: viewModel)
    }
}

struct SignUpMain: View {
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                // Main content
                SignUpContent(viewModel: viewModel)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SignUpContent: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(alignment: .center) {
                    Text("Sign Up").font(.largeTitle).padding()
                }
                
                SignUpInput(viewModel: viewModel)
            }
            Spacer()
            SignUpButton(presentationMode: self.presentationMode, viewModel: viewModel)
            
            // Navigate back to login
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Text("Already have an account? Login").font(.custom("Inter Semi Bold", size: 16)).foregroundColor(Color("Secondary")).multilineTextAlignment(.center)
                }.padding(.top, 5)
            }
        }
        .alert(isPresented: $viewModel.error, content: {
            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage ?? "unknown error occurred")"), dismissButton: Alert.Button.cancel(Text("Okay")))
        })
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct SignUpInput: View {
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            InputField(fieldHeight: 15, placeholder: "First Name", value: $viewModel.firstName).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,placeholder: "Last Name", value: $viewModel.lastName).padding(.bottom, 10).padding(.horizontal, 17.5)
            InputField(fieldHeight: 15,textStyle: .emailAddress, autoCap: false, placeholder: "Email", value: $viewModel.email).padding(.bottom, 10).padding(.horizontal, 17.5)
            
            if !viewModel.showPassword {
                SecureInputField(fieldHeight: 15,placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
            } else {
                InputField(fieldHeight: 15, autoCap: false, placeholder: "Password", value: $viewModel.password).padding(.bottom, 10).padding(.horizontal, 17.5)
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
        }
    }
}

struct SignUpButton: View {
    var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        PrimaryButtonView(title: "Sign Up", action: {
            if viewModel.password.count > 0 && viewModel.password == viewModel.passwordCheck && viewModel.firstName.count > 0 && viewModel.lastName.count > 0 && viewModel.email.count > 0 {
                // Validation passes, Sign up user
                self.viewModel.performSignUp() {
                    (success, message) in
                    
                    if success {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.viewModel.error.toggle()
                        self.viewModel.errorMessage = "User was not created. \(message!)"
                    }
                }
            } else {
                // Validation failed
                if viewModel.password != viewModel.passwordCheck {
                    self.viewModel.error.toggle()
                    self.viewModel.errorMessage = "Passwords do not match"
                } else {
                    self.viewModel.error.toggle()
                    self.viewModel.errorMessage = "Please make sure all fields are filled in correctly."
                }
            }
        })
    }
}
