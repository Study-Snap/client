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
    @Binding var showEdit: Bool
    @ObservedObject var viewModel: DetailedNoteViewViewModel
    
    
    var body: some View {
        
        
        
        ZStack{
            Color("Accent")
            VStack{
                Text("Edit Note")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                
                GeometryReader{ geo in
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
                        Button(action: {
                            if !self.title.isEmpty || !self.shortDescription.isEmpty{
                                
                                self.viewModel.noteObj.title! = !self.title.isEmpty ? self.title : self.viewModel.noteObj.title!
                                self.viewModel.noteObj.shortDescription! = !self.shortDescription.isEmpty ? self.shortDescription : self.viewModel.noteObj.shortDescription!
                                
                                self.viewModel.performUpdateNote(noteData: self.viewModel.noteObj) {
                                    if self.viewModel.unauthorized {
                                        // Refresh failed, return to login
                                        self.rootIsActive = false
                                    }
                                    self.showEdit = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }else{
                                self.showEdit = false
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }
                            
                        }) {
                            Text("Update")
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                                .frame(minWidth: geo.size.width, maxWidth: .infinity, minHeight:0, maxHeight: 60, alignment: .center)

                        }
                        
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: 60, alignment: .center)
                        .background(Color("Primary"))
                        .cornerRadius(12)
                        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x:0, y: 5)
                        .strokeStyle()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 40)
                    }
                    
                }
                
            }
            .padding(.top, 10)
            .onAppear { //UINavigationBar.appearance().backgroundColor = UIColor(Color("Accent"))
                self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
            .alert(isPresented: self.$viewModel.error, content: {
                Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage ?? "No message provided"), dismissButton: Alert.Button.cancel(Text("Okay")))
            })
            
        }
        
    }
}

/*struct EditNoteView_Previews: PreviewProvider {
 @Binding var isNavigationBarHidden: Bool
 init(isNavigationBarHidden: Binding<Bool>) {
 _isNavigationBarHidden = .constant(false)
 }
 static var previews: some View{
 Group {
 EditNoteView(rootIsActive: .constant(true), showEdit: .constant(true), viewModel: DetailedNoteViewViewModel())
 
 .preferredColorScheme(.dark)
 
 }
 }
 }*/
