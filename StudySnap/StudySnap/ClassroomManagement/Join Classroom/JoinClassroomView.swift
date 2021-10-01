//
//  JoinClassroomView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct JoinClassroomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: JoinClassroomViewModel = JoinClassroomViewModel()
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter the class invitation code", value: $viewModel.classId).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Join", action: {
                    self.viewModel.joinUserClassroom(classId: viewModel.classId)
                    presentationMode.wrappedValue.dismiss()
                }).padding()
            }.navigationBarTitle("Join Classroom", displayMode: .inline)
        }
    }
}

struct JoinClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinClassroomView()
    }
}
