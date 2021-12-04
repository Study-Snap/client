//
//  RecommendationView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct ProfileView: View {
    // Global
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var rootIsActive: Bool
    
    // State info
    @StateObject var viewModel : ProfileViewViewModel = ProfileViewViewModel()
    @State var error: Bool = false
    @State var deauthenticated: Bool = false
    
    // Sheet values
    @State private var showChangePassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.response == nil {
                        // Loading still
                        ProgressView("Loading user profile")
                            .foregroundColor(Color("Secondary"))
                    } else {
                        VStack {
                            List {
                                Section {
                                    VStack(alignment: .leading){
                                        Text("Full Name")
                                            .foregroundColor(Color("Primary"))
                                            .font(.system(size: 15))
                                            .padding(.bottom, 3)
                                        Text("\((viewModel.response?.firstName)!) \((viewModel.response?.lastName)!)").fontWeight(.light)
                                            .font(.system(size: 20))
                                    }

                                    VStack(alignment: .leading){
                                        Text("Email")
                                            .foregroundColor(Color("Primary"))
                                            .font(.system(size: 15))
                                            .padding(.bottom, 3)
                                        Text((viewModel.response?.email)!).fontWeight(.light)
                                            .font(.system(size: 20))
                                    }

                                }.accentColor(.primary)

                                Section {
                                    // TODO: Implement change password =)
                                    Button("Change Password") {
                                        showChangePassword = true
                                    }.buttonStyle(BorderlessButtonStyle()).sheet(isPresented: $showChangePassword) {
                                        ChangePasswordView(rootIsActive: self.$rootIsActive)
                                    }
                                    
                                    
                                    Button("Log Out") {
                                        self.viewModel.performLogout()
                                        if (self.viewModel.logout) {
                                            self.rootIsActive = false
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }.buttonStyle(BorderlessButtonStyle()).foregroundColor(.red)
                                }.accentColor(.primary)
                            }.listStyle(.insetGrouped)
                             .navigationTitle("Profile")
                        }
                    }
                }
            }
        }.onAppear(perform: {
            self.viewModel.getUserInformation() {
                if self.viewModel.unauthorized {
                    // If we cannot refresh, pop off back to login
                    self.rootIsActive = false
                }
                if self.viewModel.error {
                    // Unknown error getting user data -- logout user
                    self.viewModel.performLogout()
                    if (self.viewModel.logout) {
                        self.rootIsActive = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(rootIsActive: .constant(true))
    }
}
