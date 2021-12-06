//
//  NoteUploadView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-03-24.
//

import SwiftUI
import MobileCoreServices

struct Keyword: Identifiable {
    let value: String
    let id = UUID()
}

struct NoteUploadView: View {
    @Binding var rootIsActive: Bool
    @Binding var refreshClassroom: Bool
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @Environment(\.presentationMode) var presentationMode
    
    // Input state
    @State var title: String  = ""
    @State var shortDescription: String  = ""
    @State var keywordInput: String = ""
    @State var keywords: [Keyword]  = []
    @State var classRoomId: String
    @State var citationAuthorFirstName: String = ""
    @State var citationAuthorLastName: String = ""
    @State var citationTitle: String = ""
    @State var citationYear: String = ""
    @State var fullCitation: String = ""
    
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
                if (self.loading && !self.viewModel.error) {
                    ProgressView("Creating your Note!")
                        .foregroundColor(Color("Secondary"))
                } else {
                    ScrollView {
                        // Input section
                        Text("Required Information")
                            .font(.caption)
                            .foregroundColor(Color("Primary"))
                        InputField(placeholder: "Title", value: $title)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 10)
                            .background(GeometryGetter(rect: $kGuardian.rects[0]))
                        InputField(autoCap: false, placeholder: "Enter a short description", value: $shortDescription)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 10)
                            .background(GeometryGetter(rect: $kGuardian.rects[1]))
                        VStack {
                            // MARK: Keyword entry (start)
                            HStack {
                                InputField(placeholder: "Enter a Keyword", value: $keywordInput)
                                    .padding(.horizontal, 5)
                                    .padding(.bottom, 10)
                                    .background(GeometryGetter(rect: $kGuardian.rects[2]))
                                Button(action: {
                                    if self.keywords.count < 5 && !self.keywordInput.isEmpty {
                                        // Add keyword to keywords if under 5
                                        let trimmedKeyword = self.keywordInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                                        self.keywords.append(Keyword(value: trimmedKeyword.components(separatedBy: " ").first ?? trimmedKeyword))
                                        self.keywordInput = ""
                                    }
                                }, label: {
                                    Text("+")
                                        .padding(.horizontal, 25)
                                        .padding(.vertical, 10)
                                        .accentColor(.white)
                                        .background(Color("Primary"))
                                        .cornerRadius(7)
                                        .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color("TextFieldPrimary")))
                                })
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 10)
                            }
                            HStack {
                                ForEach(keywords) { word in
                                    KeywordListItemView(keyword: word.value)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            // MARK: Keyword entry (end)
                        }
                        
                        
                        Text("Citation Information (Optional)")
                            .font(.caption)
                            .foregroundColor(Color("Primary"))
                        HStack {
                            InputField(placeholder: "Author First Name (optional)", value: $citationAuthorFirstName)
                                .background(GeometryGetter(rect: $kGuardian.rects[2]))
                            Spacer()
                            InputField(placeholder: "Author Last Name (optional)", value: $citationAuthorLastName)
                                .background(GeometryGetter(rect: $kGuardian.rects[2]))
                        }
                        .padding(.horizontal, 5)
                        .padding(.bottom, 10)
                        InputField(placeholder: "Title of content being cited (Optional)", value: $citationTitle)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 10)
                            .background(GeometryGetter(rect: $kGuardian.rects[2]))
                        InputField(placeholder: "Year of content being cited (Optional)", value: $citationYear)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 10)
                            .background(GeometryGetter(rect: $kGuardian.rects[2]))

                        HStack {
                            Button(action: {
                                self.showNotePicker.toggle()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("Accent"))
                                        .cornerRadius(10)

                                    
                                    VStack {
                                        Image(systemName: "icloud.and.arrow.up")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color("Secondary"))
                                            .frame(width: 40, height: 50, alignment: .center)
                                            .padding(.top)
                                        Text("Upload PDF from Device")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("Secondary").opacity(0.6))
                                            .padding(.bottom)
                                    }
                                }
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
                                        .cornerRadius(10)
                                                
                                        VStack {
                                            Image(systemName: "highlighter")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("Secondary"))
                                                .frame(width: 40, height: 50, alignment: .center)
                                                .padding(.top)
                                                Text("Upload Handwritten Note")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color("Secondary").opacity(0.6))
                                                    .padding(.bottom)
                                                }
                                            }
                                        .background(GeometryGetter(rect: $kGuardian.rects[3]))
                                        .sheet(isPresented: $showScanView) {
                                            ScanNoteView(pagesText: $pagesText, didCompleteScan: $didCompleteScan)
                                        }
                                }
                        }.padding(.horizontal, 5)
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
                        self.loading = true // Start loading indication
                                            
                        if !self.citationAuthorFirstName.isEmpty && !self.citationAuthorFirstName.isEmpty && !self.citationTitle.isEmpty && !self.citationYear.isEmpty {
                            self.fullCitation = "@article{ahu61, author={" + self.citationAuthorFirstName + " and " + self.citationAuthorLastName + "}, title={" + self.citationTitle + "}, year=" + self.citationYear + "}"
                        }
                        let keywordValues: [String] = self.keywords.map { $0.value }
                        self.viewModel.performUpload(noteData: CreateNoteData(title: self.title, classId: self.classRoomId, keywords: keywordValues, shortDescription: self.shortDescription, fileName: self.pickedFileName, fileData: self.pickedFile, bibtextCitation: self.fullCitation)) {
                            
                            if self.viewModel.unauthorized {
                                // Pop to root
                                self.rootIsActive = false
                            }
                            
                            // Stop loading
                            self.loading = false
                            
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
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
            .alert(isPresented: self.$viewModel.error, content: {
                Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage ?? "No message provided"), dismissButton: Alert.Button.cancel(Text("Okay"), action: {self.loading = false}))
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
