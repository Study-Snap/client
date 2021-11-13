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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.response == nil || viewModel.userClassroomResponse == nil {
                        // Loading still
                        ProgressView("Loading user profile")
                            .foregroundColor(Color("Secondary"))
                    } else {
                        NavigationView {
                            List {
                                Section {
                                    Text("Full Name")
                                        .foregroundColor(Color("Primary"))
                                        .font(.system(size: 15))
                                    Text("\((viewModel.response?.firstName)!) \((viewModel.response?.lastName)!)").fontWeight(.light)
                                        .font(.system(size: 20))
                                    Text("Email")
                                        .foregroundColor(Color("Primary"))
                                        .font(.system(size: 15))
                                    Text((viewModel.response?.email)!).fontWeight(.light)
                                        .font(.system(size: 20))
                                    Text("Unique ID")
                                        .foregroundColor(Color("Primary"))
                                        .font(.system(size: 15))
                                    let idString = String((viewModel.response?.id)!)
                                    Text(idString).fontWeight(.light)
                                        .font(.system(size: 20))
                                    Text("Number of Classrooms")
                                        .foregroundColor(Color("Primary"))
                                        .font(.system(size: 15))
                                    Text(String((viewModel.userClassroomResponse?.count) ?? 0)).fontWeight(.light)
                                        .font(.system(size: 20))
                                    Text("Number of Uploaded Notes")
                                        .foregroundColor(Color("Primary"))
                                        .font(.system(size: 15))
                                    Text(String((viewModel.userNoteResponse?.count) ?? 0)).fontWeight(.light)
                                        .font(.system(size: 20))
                                }.accentColor(.primary)
                                    .listRowSeparatorTint(.blue)
                                    .listRowSeparator(.hidden)
                            }.listStyle(.insetGrouped)
                             .navigationTitle("My Profile")
                        }.navigationBarTitle("")
                        .navigationBarHidden(true)
                    }

                    
                    NavigationView {
                        List {
                            Section {
                                // TODO: Implement change password
                                Button("Change Password") {
                                    print("Implement change password")
                                }.buttonStyle(BorderlessButtonStyle())
                                
                                Button("Log Out") {
                                    self.viewModel.performLogout()
                                    if (self.viewModel.logout) {
                                        self.rootIsActive = false
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }.buttonStyle(BorderlessButtonStyle())
                            }.accentColor(.primary)
                        }.listStyle(.insetGrouped)
                         .navigationTitle("Settings")
                    }.navigationBarTitle("")
                        .navigationBarHidden(true)
                        .frame(maxHeight: .infinity, alignment: .bottom)
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
            self.viewModel.getUserClassrooms() {
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
            
            self.viewModel.getUserNotes() {
                
                if self.viewModel.unauthorized {
                    // If we cannot refresh, pop off back to login
                    self.rootIsActive = false
                }
                if self.viewModel.error {
                    // No notes or some other error
                    print("\(self.viewModel.error), \(self.viewModel.errorMessage ?? "No message.")")
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
