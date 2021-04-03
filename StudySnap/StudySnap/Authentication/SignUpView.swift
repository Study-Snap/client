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
            
            Button(action: {
                // Perform Sign Up
                AuthApi().register(firstName: firstName, lastName: lastName, email: email, password: password) {
                    (user) in
                    print(user.firstName)
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Primary"))
                        .frame(width: 370, height: 60)
                    
                    Text("Sign Up").font(.custom("Inter Semi Bold", size: 24)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                }
            })
            NavigationLink(
                destination: LoginView(),
                label: {
                    ZStack {
                        Text("Already have an account? Login").font(.custom("Inter Semi Bold", size: 16)).foregroundColor(Color("Secondary")).multilineTextAlignment(.center)
                    }.padding()
                })
        }.navigationBarHidden(true).navigationTitle("").navigationBarBackButtonHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

// Functions

// Components
struct InputField: View {
    // Styles
    var cornerRadius: CGFloat = 7.0
    var fieldHeight: CGFloat = 10.0
    var backgroundColor: Color = Color("Accent")
    var textColor: Color = Color("TextFieldPrimary")
    var borderColor: Color = Color("TextFieldPrimary")
    var textStyle: UITextContentType = .name
    var autoCap: Bool = true
    
    // Variables
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
            TextField(placeholder, text: $value)
                .padding(.vertical, fieldHeight)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: self.cornerRadius).foregroundColor(self.backgroundColor))
                .font(.body)
                .foregroundColor(self.textColor)
                .overlay(RoundedRectangle(cornerRadius: self.cornerRadius).stroke(self.borderColor))
                .textContentType(textStyle)
                .autocapitalization(autoCap ? .words : .none)
    }
}

struct SecureInputField: View {
    // Styles
    var cornerRadius: CGFloat = 7.0
    var fieldHeight: CGFloat = 10.0
    var backgroundColor: Color = Color("Accent")
    var textColor: Color = Color("TextFieldPrimary")
    var borderColor: Color = Color("TextFieldPrimary")
    
    // Variables
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
            SecureField(placeholder, text: $value)
                .padding(.vertical, fieldHeight)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: self.cornerRadius).foregroundColor(self.backgroundColor))
                .font(.body)
            .foregroundColor(self.textColor)
            .overlay(RoundedRectangle(cornerRadius: self.cornerRadius).stroke(self.borderColor))
    }
}
