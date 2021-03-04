//
//  SignUpView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        self.navigationBarHidden(true).navigationTitle("")
        Text("Sign Up Now!")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
