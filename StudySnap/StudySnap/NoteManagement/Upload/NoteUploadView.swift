//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-03-24.
//

import SwiftUI
import MobileCoreServices

struct NoteUploadView: View {
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @ObservedObject var globalString = globalEventManager
    @Environment(\.presentationMode) var presentationMode
    
    // Input state
    @State var title: String  = ""
    @State var keywords: String  = ""
    @State var subject: String  = ""
    
    // File picker state
    @State var pickedFile: String = ""
    @State var show: Bool = false
    @State var alert: Bool = false
    @State var imageUrl: String = ""
    
    let formatter: NumberFormatter = {
     let formatter = NumberFormatter()
     formatter.numberStyle = .decimal
     return formatter
     }()
    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .center) {
                    Text("Note Upload")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, -50)
                }
                
                // Input section
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
            
                Button(action: {
                    self.show.toggle()
                }) {
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
                    .sheet(isPresented: $show) {
                        DocumentPicker(alert: self.$alert, picked_file: self.$pickedFile)
                    }
                }
                
                if self.pickedFile.count > 0 {
                    FilePickedView(picked_file: self.pickedFile)
                }
                Spacer()
                PrimaryButtonView(title: "Upload") {
//                    self.presentationMode.wrappedValue.dismiss()
                    print(self.pickedFile)
                }
     
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
            .navigationBarItems(trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width:25, height:25)
                            .foregroundColor(Color("Secondary"))
                    
                    }
            )
            
        }
        .background(Color(UIColor.systemBackground))
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()
    }
}

struct DocumentPicker : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    @Binding var alert : Bool
    @Binding var picked_file : String
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) ->  UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>){
        
    }
    
    class Coordinator : NSObject, UIDocumentPickerDelegate{
        var parent : DocumentPicker
        
        init(parent1 : DocumentPicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.parent.picked_file = (urls.first?.deletingPathExtension().lastPathComponent)!
            
        }
    }
}

struct NoteUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NoteUploadView()
    }
}
