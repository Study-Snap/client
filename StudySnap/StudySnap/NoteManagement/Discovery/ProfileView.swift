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
                    HStack (alignment: .center) {
                        Text("My Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, -50)
                    }
                    
                    if viewModel.response == nil {
                        // Loading still
                        ProgressView("Loading user profile")
                            .foregroundColor(Color("Secondary"))
                    } else {
                        VStack(alignment: .leading){
                            VStack(alignment: .leading) {
                                Text("Full Name")
                                    .font(.caption)
                                    .foregroundColor(Color("Primary"))
                                
                                Text("\((viewModel.response?.firstName)!) \((viewModel.response?.lastName)!)").fontWeight(.light)
                            }
                            .padding()
                            
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(Color("Primary"))
                                
                                Text((viewModel.response?.email)!).fontWeight(.light)
                            }.padding()
                            
                            VStack(alignment: .leading) {
                                Text("Unique ID")
                                    .font(.caption)
                                    .foregroundColor(Color("Primary"))
                                let idString = String((viewModel.response?.id)!)
                                Text(idString).fontWeight(.light)
                            }.padding()
                            
                        }
                    }
                    
                    Spacer()
                    
                    // TODO: Insert change password button and add functionality
                    
                    PrimaryButtonView(title: "Log Out", action: {
                        self.viewModel.performLogout()
                        if (self.viewModel.logout) {
                            self.rootIsActive = false
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }).alert("Error", isPresented: $error) {
                        Button("Ok", role: .cancel) {
                            self.error = false
                        }
                    } message: {
                        Text("Error signing out.")
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
                    // Unknown erro getting user data -- logout user
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
