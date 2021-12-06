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
    @State var incompleteEntry: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter the class invitation code", value: $viewModel.classId).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                Spacer()
                PrimaryButtonView(title:"Join", action: {
                    if (!self.viewModel.classId.isEmpty) {
                        self.viewModel.joinUserClassroom(classId: viewModel.classId) {
                            if self.viewModel.unauthorized {
                                // Refresh failed, return to login
                                self.rootIsActive = false
                                return
                            }
                            
                            if !self.viewModel.error {
                                self.isClassroomsUpdated = true
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } else {
                        self.incompleteEntry = true
                    }
                })
                    .alert("Error", isPresented: self.$viewModel.error) {
                        Button("Ok", role: .cancel){
                            self.viewModel.classId = ""
                            self.incompleteEntry = false
                        }
                    } message:{
                        Text("\(self.viewModel.errorMessage ?? "Unknown Failure")")
                    }
                    .padding()
            }
            .alert("Error: Missing information", isPresented: $incompleteEntry) {
                Button("Ok", role: .cancel){
                    self.incompleteEntry = false
                }
            } message:{
                Text("Please enter a valid invite code")
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
