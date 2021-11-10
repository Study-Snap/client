//
//  CreateClassroomView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct CreateClassroomView: View {
    // Global
    @Environment(\.presentationMode) var presentationMode
    @Binding var rootIsActive: Bool
    
    // State
    @StateObject var viewModel: CreateClassroomViewModel = CreateClassroomViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter a classroom name", value: $viewModel.name).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Create", action: {
                    self.viewModel.postUserClassroom(className: viewModel.name, classThumbnail: viewModel.thumbnail) {
                        if self.viewModel.unauthorized {
                            // Refresh failed, return to login
                            self.rootIsActive = false
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                })
                .padding()
            }.navigationBarTitle("Create Classroom", displayMode: .inline)
        }
    }
}

struct CreateClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateClassroomView(rootIsActive: .constant(true))
    }
}
