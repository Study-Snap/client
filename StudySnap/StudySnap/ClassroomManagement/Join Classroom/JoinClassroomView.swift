//
//  JoinClassroomView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct JoinClassroomView: View {
    // Global
    @Environment(\.presentationMode) var presentationMode
    @Binding var rootIsActive: Bool
    
    // State
    @StateObject var viewModel: JoinClassroomViewModel = JoinClassroomViewModel()
    
    @Binding var isClassroomsUpdated: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter the class invitation code", value: $viewModel.classId).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Join", action: {
                    self.viewModel.joinUserClassroom(classId: viewModel.classId) {
                        if self.viewModel.unauthorized {
                            // Refresh failed, return to login
                            self.rootIsActive = false
                        } else {
                            self.isClassroomsUpdated = true
                        }
                        // No issues... dismiss the view
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }).padding()
            }
            .navigationBarTitle("Join Classroom", displayMode: .inline)
        }
    }
}

struct JoinClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinClassroomView(rootIsActive: .constant(true), isClassroomsUpdated: .constant(false))
    }
}
