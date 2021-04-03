//
//  LoginView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-03.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: SignUpView(),
                label: {
                    Text("Sign Up")
                })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
