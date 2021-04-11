//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct NoteUploadView: View {
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @Environment(\.presentationMode) var presentationMode
    @State var title: String  = ""
    @State var keywords: String  = ""
    @State var subject: String  = ""
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
                HStack (alignment: .center) {
                    Text("Note Upload")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, -50)
                }
                        //Note Upload
                InputField(placeholder: "Title", value: $title)
                    .padding(.top, 20)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[0]))
                InputField(placeholder: "Subject", value: $subject)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[1]))
                InputField(placeholder: "Keywords (press return to confirm)", value: $keywords)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[2]))
                
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Accent"))
                                .cornerRadius(20)
                                .padding(.bottom)
                                .padding(.horizontal, 7)
                            
                            VStack {
                                Image(systemName: "icloud.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("Secondary"))
                                    .frame(width: 80, height: 45, alignment: .center)
                                Text("Select a PDF to Upload")
                                    .padding(.top, 10)
                                    .foregroundColor(Color("Secondary").opacity(0.6))
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .background(GeometryGetter(rect: $kGuardian.rects[3]))
                        
                PrimaryButtonView(title: "Upload") {
                    self.presentationMode.wrappedValue.dismiss()
                }
     
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
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
