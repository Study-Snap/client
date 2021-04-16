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
    @State var shortDescription: String  = ""
    @State var keywords: String  = ""
    @State var isPublic: Bool = false
    @State var allowDownloads: Bool = false
    
    // File picker state
    @State var pickedFileName: String = ""
    @State var pickedFile: Data = Data()
    @State var show: Bool = false
    @State var alert: Bool = false
    
    // Note upload View Model
    @ObservedObject var viewModel: NoteUploadViewModel = NoteUploadViewModel()
    
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
                InputField(autoCap: false, placeholder: "Enter a short description", value: $shortDescription)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[1]))
                InputField(placeholder: "Keywords (press return to confirm)", value: $keywords)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[2]))
                Toggle(isOn: self.$isPublic, label: {
                    Image(systemName: "globe").foregroundColor(Color("Secondary"))
                    Text("Make Public")
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(Color("Secondary"))
                })
                .toggleStyle(SwitchToggleStyle(tint: Color("Primary")))
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                Toggle(isOn: self.$allowDownloads, label: {
                    Image(systemName: "arrow.down.square").foregroundColor(Color("Secondary"))
                    Text("Make Downloadable")
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(Color("Secondary"))
                })
                .toggleStyle(SwitchToggleStyle(tint: Color("Primary")))
                .padding(.horizontal)
                .padding(.bottom, 15)
                
            
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
                        DocumentPicker(alert: self.$alert, picked_file_name: self.$pickedFileName, picked_file_data: self.$pickedFile)
                    }
                }
                
                if self.pickedFileName.count > 0 {
                    FilePickedView(picked_file: self.pickedFileName)
                }
                Spacer()
                PrimaryButtonView(title: "Upload") {
                    self.viewModel.performUpload(noteData: CreateNoteData(title: self.title, keywords: self.keywords.components(separatedBy: ", "), shortDescription: self.shortDescription, fileName: self.pickedFileName, fileData: self.pickedFile, isPublic: self.isPublic, allowDownloads: self.allowDownloads, bibtextCitation: nil))
                    
                    // If successful dismiss the upload view
                    if !self.viewModel.error {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
     
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
            .alert(isPresented: self.$viewModel.error, content: {
                Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage ?? "No message provided"), dismissButton: Alert.Button.cancel(Text("Okay")))
            })
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
    @Binding var picked_file_name : String
    @Binding var picked_file_data : Data
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
            guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            defer {
                    DispatchQueue.main.async {
                        url.stopAccessingSecurityScopedResource()
                    }
            }
            // Get file data
            self.parent.picked_file_name = (urls.first?.lastPathComponent)!
            self.parent.picked_file_data = try! Data.init(contentsOf: urls.first!)
        }
    }
}

struct NoteUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NoteUploadView()
    }
}
