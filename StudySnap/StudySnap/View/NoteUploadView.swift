//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct NoteUploadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var textValue = ""
    var body: some View {
        //Note Upload
        NavigationView {
            VStack {
                //Note Upload
                
                
                
                VStack {
                    VStack {
                        
                        //Note Upload
                        
                        TextField("Title", text: $textValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 10)
                        TextField("Author", text: $textValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        TextField("Keywords", text: $textValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        TextField("Subject", text: $textValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        TextField("Length", text: $textValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(#colorLiteral(red: 0.9647058844566345, green: 0.9647058844566345, blue: 0.9647058844566345, alpha: 1)))
                                .cornerRadius(20)
                                .padding(.bottom)
                            
                            
                            Image(systemName: "icloud.and.arrow.up")
                                .resizable()
                                .frame(width: 80, height: 75, alignment: .center)
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Primary"))
                                .frame(width: 370, height: 70)
                            
                            //Upload!
                            Text("Upload!").font(.custom("Inter Semi Bold", size: 24)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                                .padding()
                        }
                        
                    }.padding()
                }
                //Rectangle 2
                
                
                
                
                
                
            }.navigationTitle(//Note Upload
                Text("Note Upload"))
            .navigationBarItems(
                trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
            )
            
        }
                                     
    }
}

struct NoteUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NoteUploadView()
    }
}
