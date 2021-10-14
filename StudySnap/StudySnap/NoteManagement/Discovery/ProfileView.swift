//
//  RecommendationView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("isAnimated") var isAnimated: Bool = true
    
    @StateObject var viewModel : ProfileViewViewModel = ProfileViewViewModel()
    @State var showError: Bool = false
    @State var deauthenticated: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    PrimaryButtonView(title: "Log Out", action: {
                        self.viewModel.performLogout()
                        if (self.viewModel.logout) {
                            self.presentationMode.wrappedValue.dismiss()
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
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
