//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-03-24.
//

import SwiftUI
import MobileCoreServices

struct NoteUploadView: View {
    @Binding var rootIsActive: Bool
    @Binding var refreshClassroom: Bool
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @Environment(\.presentationMode) var presentationMode
    
    // Input state
    @State var title: String  = ""
    @State var shortDescription: String  = ""
    @State var keywords: String  = ""
    @State var classRoomId: String
    
    // File picker state
    @State var pickedFileName: String = ""
    @State var pickedFile: Data = Data()
    @State var showNotePicker: Bool = false
    @State var showScanView: Bool = false
    @State var alert: Bool = false
    
    // Scanned documents state
    @State var didCompleteScan: Bool = false
    @State var pagesText: [String] = []
    
    // Upload State
    @State var loading: Bool = false
    
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
                
                ScrollView {
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
                
                
            
                    Button(action: {
                        self.showNotePicker.toggle()
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
                                    .frame(width: 80, height: 25, alignment: .center)
                                Text("Upload PDF from Device")
                                    .padding(.top, 2)
                                    .foregroundColor(Color("Secondary").opacity(0.6))
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .background(GeometryGetter(rect: $kGuardian.rects[3]))
                        .sheet(isPresented: $showNotePicker) {
                            DocumentPicker(alert: self.$alert, picked_file_name: self.$pickedFileName, picked_file_data: self.$pickedFile)
                        }
                    }
                    
                    Button(action: {
                        self.showScanView.toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Accent"))
                                .cornerRadius(20)
                                .padding(.bottom)
                                .padding(.horizontal, 7)
                                        
                                VStack {
                                    Image(systemName: "highlighter")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color("Secondary"))
                                        .frame(width: 80, height: 25, alignment: .center)
                                        Text("Upload Handwritten Note")
                                            .padding(.top, 2)
                                            .foregroundColor(Color("Secondary").opacity(0.6))
                                        }
                                    }
                                .aspectRatio(contentMode: .fill)
                                .background(GeometryGetter(rect: $kGuardian.rects[3]))
                                .sheet(isPresented: $showScanView) {
                                    ScanNoteView(pagesText: $pagesText, didCompleteScan: $didCompleteScan)
                                }
                        }
                }
                
                NavigationLink(destination: NoteEditorView(pagesText: $pagesText, pickedFile: $pickedFile, pickedFileName: $pickedFileName, didCompleteScan: $didCompleteScan).navigationBarTitle("")
                    .navigationBarHidden(true), isActive: $didCompleteScan) {
                    EmptyView()
                }
                
                if self.pickedFileName.count > 1 {
                    FilePickedView(pickedFile: $pickedFile, pickedFileName: $pickedFileName)
                }
                Spacer()
                PrimaryButtonView(title: "Upload") {
                    self.loading.toggle() // Start loading indication
                    self.viewModel.performUpload(noteData: CreateNoteData(title: self.title, classId: self.classRoomId, keywords: self.keywords.components(separatedBy: ", "), shortDescription: self.shortDescription, fileName: self.pickedFileName, fileData: self.pickedFile, bibtextCitation: nil)) {
                        
                        if self.viewModel.unauthorized {
                            // Pop to root
                            self.rootIsActive = false
                        }
                        
                        // Stop loading
                        self.loading.toggle()
                        
                        // If successful dismiss the upload view
                        if !self.viewModel.error {
                            // Successful upload
                            // MARK: (init jiggle)
                            self.refreshClassroom = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
     
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
            .alert(isPresented: self.$viewModel.error, content: {
                Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage ?? "No message provided"), dismissButton: Alert.Button.cancel(Text("Okay")))
            })

            
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
        NoteUploadView(rootIsActive: .constant(true), refreshClassroom: .constant(false), classRoomId: "jjiw7793ggus8810")
    }
}
