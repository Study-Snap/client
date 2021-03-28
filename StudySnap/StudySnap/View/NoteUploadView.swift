//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct NoteUploadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String  = ""
    @State var author: String  = ""
    @State var keywords: String  = ""
    @State var subject: String  = ""
    @State var length: String =  ""
    //@State var notes: [Note] = Bundle.main.decode("notes_data.json")
    @ObservedObject var globalString = GlobalString()
//    func writeJSON(items: [Note]) {
//     do {
//     let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//     .appendingPathComponent("notes_data.json")
//
//     let encoder = JSONEncoder()
//        try encoder.encode(globalString.notesData).write(to: fileURL)
//     } catch {
//     print(error.localizedDescription)
//     }
//     }
    let formatter: NumberFormatter = {
     let formatter = NumberFormatter()
     formatter.numberStyle = .decimal
     return formatter
     }()
    var body: some View {
        
        //Note Upload
        NavigationView {
            VStack {
                //Note Upload
                
                        //Note Upload
                        
                        TextField("Title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .padding(.vertical, 10)
                        
                        TextField("Author", text: $author)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .padding(.bottom, 10)
                        
                        TextField("Keywords", text: $keywords)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .padding(.bottom, 10)
                        TextField("Subject", text: $subject)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .padding(.bottom, 10)
                        TextField("Length", text: $length)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .padding(.bottom, 10)
                        
                        
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.lightGray))
                                .cornerRadius(20)
                                .padding(.bottom)
                            
                            
                            Image(systemName: "icloud.and.arrow.up")
                                .resizable()
                                .frame(width: 80, height: 75, alignment: .center)
                        }
                        
                        
                        Button(action: {
                            
//                            globalString.notesData.append(Note(id: 26,title: title, author: author, keywords: [keywords], subject: [subject], length: 25, image: "doc.text.fill", isOnline: false, rating: 3, description: "This is some random text to check note insertion"))
//
//
//                            writeJSON(items: globalString.notesData)
//
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("Primary"))
                                    .frame(width: 370, height: 70)
                                
                                
                                //Upload!
                                Text("Upload!").font(.custom("Inter Semi Bold", size: 24)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            }
                        }
                        
                        
                  
                
                //Rectangle 2
     
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width:25, height:25)
                            .foregroundColor(Color("Primary"))
                    
                    }
            )
            .navigationTitle("Note Upload")
            
        }.background(Color(UIColor.systemBackground))
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()
        
                                     
    }
}

struct NoteUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NoteUploadView()
    }
}
