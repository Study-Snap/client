//
//  RecommendationView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isAnimated") var isAnimated: Bool = true
    
    @State var showError: Bool = false
    @State var deauthenticated: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    PrimaryButtonView(title: "Log Out", action: {
                        AuthApi().deauthenticate { completed, message in
                            if !completed {
                                self.showError = true
                            } else {
                                self.deauthenticated = true
                            }
                        }
                    }).alert("Error", isPresented: $showError) {
                        Button("Ok", role: .cancel) {
                            self.showError = false
                        }
                    } message: {
                        Text("Error signing out.")
                    }
                }
            }
            NavigationLink(destination: LoginView().navigationBarTitle("")
                .navigationBarHidden(true), isActive: $deauthenticated) {
                EmptyView()
            }

        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
