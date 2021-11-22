//
//  ChangePasswordView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-11-22.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // View Model
    @StateObject var viewModel: ChangePasswordViewModel = ChangePasswordViewModel()
    
    @Binding var rootIsActive : Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text("Change Password").font(.largeTitle).padding()
                }
                    
                // Input fields
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter old password", value: $viewModel.password).padding(.top, 20).padding(.horizontal, 17.5)
                
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter new password", value: $viewModel.newPassword).padding(.top, 20).padding(.horizontal, 17.5)
                    
                Spacer()
                    
                PrimaryButtonView(title: "Change Password", action: {
                    // Log in user
                    if self.viewModel.password.isEmpty || self.viewModel.newPassword.isEmpty {
                        // Validation error
                        self.viewModel.error = true
                        self.viewModel.errorMessage = "Make sure both your old and new passwords are entered!"
                    } else {
                        self.viewModel.changePassword(completion: {
                            if self.viewModel.unauthorized {
                                self.rootIsActive = false
                            }
                            
                        })
                    }
                }).padding(.horizontal, 20)
            }.navigationBarHidden(true)
                .alert("Change Password Failure", isPresented: self.$viewModel.error) {
                    Button("Okay", role: .cancel) {
                        // Sheharyaar
                    }
                } message:{
                    Text("Failed to change password. Reason: \(self.viewModel.errorMessage)")
                }
                .alert("Change Password Success", isPresented: self.$viewModel.changePasswordSuccess) {
                    Button("Okay", role: .cancel){
                        self.presentationMode.wrappedValue.dismiss()
                        self.rootIsActive = false
                    }
                } message:{
                    Text("Password changed successfully. Please login with your new password.")
                }
        }
        .padding(.all, 1)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(rootIsActive: .constant(true))
    }
}
