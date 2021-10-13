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
    //@State var error: Bool = false
    //@State var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter the class invitation code", value: $viewModel.classId).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Join", action: {
                    self.viewModel.joinUserClassroom(classId: viewModel.classId)
                    presentationMode.wrappedValue.dismiss()
                }).padding()
            }
            .navigationBarTitle("Join Classroom", displayMode: .inline)
            .alert("ERROR", isPresented: $viewModel.error) {
                Button("OK", role:.cancel){
                    presentationMode.wrappedValue.dismiss()
                }
            }message: {
                Text("self.viewModel.errorMessage!")
            }
            //86baabea-9c16-4c5e-9622-8eaa90e6dd36
        }
    }
}

struct JoinClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinClassroomView()
    }
}
