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
    @State var showTermsAndConditions: Bool = false
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
                                VStack {
                                    VStack(alignment: .center){
                                        Spacer()
                                        Text("\((viewModel.response?.firstName)!) \((viewModel.response?.lastName)!)")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .padding(.top, 40)
                                            
                                        Text((viewModel.response?.email)!)
                                            .font(.subheadline)
                                            .fontWeight(.none)
                                            .padding(.bottom, 20)
                                           
                                    } .frame(maxWidth: .infinity)

                                }
                                .background(
                                    ProfileBackground()
                                        .offset(x: -50, y: -120)
                                    
                                ).accentColor(.primary)

                                Section{
                                    VStack(alignment: .center){
                                      
                                        HStack{
                                            VStack{
                                                Text("25")
                                                    .padding(.vertical, 10)
                                                    .font(.title2)
                                                    .foregroundColor(Color("Primary"))
                                                Text("Notes Published")
                                                    .font(.caption)

                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                            .padding()
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color("Primary"), lineWidth: 1)
                                            )
                                            VStack{
                                                Text("7")
                                                    .padding(.vertical, 10)
                                                    .font(.title2)
                                                    .foregroundColor(Color("Primary"))
                                                Text("Classrooms Joined")
                                                    .font(.caption)
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                            .padding()
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color("Primary"), lineWidth: 1)
                                            )
                                            
                                            
       
                                        }
                                        VStack{
                                            Text("25 mins")
                                                .padding(.vertical, 10)
                                                .font(.title2)
                                                .foregroundColor(Color("Primary"))
                                            Text("Content uploaded")
                                                .font(.caption)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color("Primary"), lineWidth: 1)
                                        )
                                      
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }

                                Section {
                                    
                                    Button {
                                        self.showTermsAndConditions = true
                                    } label: {
                                        Text("Terms & Conditions")
                                            
                                    }
                                    .alert("Terms & Conditions", isPresented: self.$showTermsAndConditions) {
                                        
                                        Button("Ok", role:.cancel){
                                            self.showTermsAndConditions = false
                                        }
                                    } message:{
                                        Text("By registering for a StudySnap account, user acknowledges that by creating an account they are agreeing to the following terms \n \n- Only notes personally written can be uploaded or must be rephrased in their own words and must reference the original author and have their consent \n \n- Uploading of any document (assignments, quizzes, tests, projects etc.) that directly relates to being a graded material is prohibited \n \n- User will not distribute the content from StudySnap to other services in an attempt to use them for personal gains and or profit from them")
                                          
                                    }
                                    
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
                        }
                    }
                }

            }.navigationBarHidden(true)
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
