//
//  EditNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-12-04.
//

import SwiftUI

struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @State private var title = ""
    @State private var shortDescription = ""
    @State private var showAlert = false
    @Binding var rootIsActive: Bool
    @ObservedObject var viewModel: DetailedNoteViewViewModel
    var body: some View {
        NavigationView{
            VStack{
    
                InputField(placeholder: "Enter a Title", value: $title)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[0]))
                InputField(autoCap: false, placeholder: "Enter a short description", value: $shortDescription)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[1]))
                Spacer()
                PrimaryButtonView(title:"Update", action: {
                    if !self.title.isEmpty || !self.shortDescription.isEmpty{
                        
                        self.viewModel.noteObj.title! = !self.title.isEmpty ? self.title : self.viewModel.noteObj.title!
                        self.viewModel.noteObj.shortDescription! = !self.shortDescription.isEmpty ? self.shortDescription : self.viewModel.noteObj.shortDescription!
                        
                        self.viewModel.performUpdateNote(noteData: self.viewModel.noteObj) {
                            if self.viewModel.unauthorized {
                                // Refresh failed, return to login
                                self.rootIsActive = false
                            }
                        self.presentationMode.wrappedValue.dismiss()
                        }
                    }else{

                        self.presentationMode.wrappedValue.dismiss()
                      
                    }

                })
                    .padding()
                    .alert("Inadequate Permissions", isPresented: self.$showAlert) {
                        Button("Ok", role: .cancel){
                            self.showAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    } message:{
                        Text("Non Admin permissions")
                    }
            }.navigationBarTitle("Edit Note", displayMode: .inline)
                .onAppear { self.kGuardian.addObserver() }
                .onDisappear { self.kGuardian.removeObserver() }
                .alert(isPresented: self.$viewModel.error, content: {
                    Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage ?? "No message provided"), dismissButton: Alert.Button.cancel(Text("Okay")))
                })
        }
    }
}


