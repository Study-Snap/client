//
//  CreateClassroomView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct CreateClassroomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CreateClassroomViewModel = CreateClassroomViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter a classroom name", value: $viewModel.name).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Create", action: {
                    presentationMode.wrappedValue.dismiss()
                })
                .padding()
            }.navigationBarTitle("Create Classroom", displayMode: .inline)
        }
    }
}

struct CreateClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateClassroomView()
    }
}
