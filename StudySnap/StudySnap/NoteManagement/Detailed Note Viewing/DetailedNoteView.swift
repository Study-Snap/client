//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI
import SwiftyBibtex
import PDFKit

struct DetailedNoteView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let noteId: Int
    
    // View model
    @StateObject var viewModel: DetailedNoteViewViewModel = DetailedNoteViewViewModel()
    @StateObject var userViewModel : ProfileViewViewModel = ProfileViewViewModel()
    //@StateObject var ratingViewModel: NoteRatingViewModel = NoteRatingViewModel()
    
    // Sheet values
    @State private var showCitation = false
    @State private var showFullNote = false
    @State private var showEditing = false
    @State private var showAlert = false
    
    // Setup citation
    @State private var citationAuthor = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var citationTitle = ""
    @State private var citationYear = ""
    @State var isRatingDsiabled = false
    
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView("Loading note details...")
                    .foregroundColor(Color("Secondary"))
            } else {
                VStack {
                    // MARK: Top (title, author, rating and keywords)
                    VStack {
                        ZStack {
                            Color("Primary").frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 240)
                            VStack {
                                Text(viewModel.noteObj.title!)
                                    .font(.title2)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: 300)
                                    .padding(.top, 25)
                                Text("\(viewModel.noteObj.user!.firstName) \(viewModel.noteObj.user!.lastName)")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                VStack {
                                    NoteRatingView(isDisabled: $isRatingDsiabled, rootIsActive: self.$rootIsActive, currentNote: self.viewModel.noteObj.id!)
                                }.padding(.vertical, 10)
                                HStack(alignment: .center) {
                                    ForEach(0..<3) { i in
                                        let keywords = viewModel.noteObj.keywords!
                                        if keywords.count > i {
                                            
                                            Text(keywords[i])
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .foregroundColor(.black.opacity(0.8))
                                                .background(Color(.white))
                                                .cornerRadius(7.0)
                                        }
                                    }
                                }
                            }.padding(.top)
                        }
                        .edgesIgnoringSafeArea(.top)
                    }.edgesIgnoringSafeArea(.top)
                    
                    
                    VStack(alignment: .leading) {
                        // MARK: Note Download Button
                        HStack {
                            Button(action: {
                                self.showFullNote = true
                                self.viewModel.getNoteFileFromCDN(fileId: self.viewModel.noteObj.fileUri!) {
                                    print("Got file...")
                                }
                            }, label: {
                                Text("Get Full Note").foregroundColor(Color("Secondary"))
                                Spacer()
                                Image(systemName: "text.viewfinder")
                                    .font(.title3)
                                    .foregroundColor(Color("Secondary"))
                                
                            })
                            Spacer()
                        }.padding()
                            .sheet(isPresented: self.$showFullNote) {
                                if self.viewModel.pdfFile == nil {
                                    ProgressView("Loading Data")
                                        .foregroundColor(Color("Secondary"))
                                } else {
                                    VStack {
                                        HStack {
                                            Button(action: {
                                                // Close the note view (PDF view)
                                                self.showFullNote = false
                                            }, label: {
                                                Text("Done").foregroundColor(Color("Secondary")).padding()
                                            })
                                            Spacer()
                                        }
                                        PDFKitView(data: self.viewModel.pdfFile!)
                                    }
                                }
                            }
                        
                            .background(Color("Accent"))
                            .cornerRadius(radius: 12, corners: [.bottomLeft, .bottomRight])
                            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                            .strokeStyle()
                        
                        
                        // MARK: Main Content
                        ScrollView {
                            VStack(alignment: .leading){
                                VStack(alignment: .leading) {
                                    Text("DESCRIPTION")
                                        .font(.caption)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.bottom, 5)
                                    
                                    Text(viewModel.noteObj.shortDescription!).font(.caption).fontWeight(.light)
                                }
                                .padding()
                                
                                VStack(alignment: .leading) {
                                    Text("ABSTRACT / NOTE INSIGHT")
                                        .font(.caption)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.bottom, 5)
                                    
                                    Text(viewModel.noteObj.noteAbstract!).font(.caption).fontWeight(.light).multilineTextAlignment(.leading)
                                }.padding()
                                
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(12)
                        
                        Spacer()
                        
                        // MARK: Bottom buttons
                        HStack(spacing: 1.0) {
                            HStack {
                                Text("\(viewModel.noteObj.timeLength!) Minute Read").foregroundColor(Color("Secondary")).padding(.vertical, 15)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .background(Color("Accent"))
                            .cornerRadius(radius: 12, corners: [.topLeft, .bottomLeft])
                            
                            
                            HStack {
                                Button(action: {
                                    if (viewModel.noteObj.bibtextCitation! != "") {
                                        do {
                                            let result = try SwiftyBibtex.parse(viewModel.noteObj.bibtextCitation!)
                                            citationAuthor = result.publications[0].fields["author"]!
                                            citationTitle = result.publications[0].fields["title"]!
                                            citationYear = result.publications[0].fields["year"]!
                                            let aBreakdown = citationAuthor.components(separatedBy: " and ")
                                            if aBreakdown.count != 2 {
                                                firstName = ""
                                                lastName = ""
                                            } else {
                                                firstName = aBreakdown[0]
                                                lastName = aBreakdown[1]
                                            }
                                        } catch {
                                            print("Error parsing citation: \(error)")
                                        }
                                    } else {
                                        citationAuthor = ""
                                        citationTitle = ""
                                        citationYear = ""
                                    }
                                    showCitation = true
                                }, label: {
                                    Text("Check Citations").accentColor(Color("Secondary")).padding(.vertical, 15)
                                }).sheet(isPresented: $showCitation) {
                                    CitationView(citation: Citation(authorFirstName: firstName, authorLastName: lastName, publishYear: Int(citationYear) ?? 1998, publishTitle: citationTitle))
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .background(Color("Accent"))
                            .cornerRadius(radius: 12, corners: [.topRight, .bottomRight])
                            
                            
                            
                            
                            
                        }
                        .padding(.horizontal)
                    }.offset(x: 0, y: -5)
                }.edgesIgnoringSafeArea(.top)
                    .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack(spacing: 5) {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        HStack(spacing: 5) {
                            Button(action: {
                               
                                if self.userViewModel.response!.id == self.viewModel.noteObj.authorId! {
                                    self.showEditing = true
                                }else{
                                    self.showAlert = true
                                }
                                
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.black)
                            }
                            .halfSheet(showSheet: self.$showEditing){
                                EditNoteView(rootIsActive: self.$rootIsActive, showEdit: self.$showEditing, viewModel: self.viewModel)
                                    .ignoresSafeArea()
                                    
                            } onEnd: {
                                
                            }
                            .alert("Inadequate Permissions", isPresented: self.$showAlert) {
                                Button("Ok", role: .cancel){
                                    self.showAlert = false
                                    
                                }
                                
                            } message:{
                                Text("You cannot make changes to someone else's note")
                            }
                            
                            //Default sheet method, if there are stability issues then use the code below and comment out the .halfSheet modifier
                            /*.sheet(isPresented: self.$showEditing) {
                                
                                EditNoteView(rootIsActive: self.$rootIsActive, viewModel: self.viewModel)
                                
                            }*/
                            
                        }
                    }
                }
            }
        }.onAppear(perform: {
            self.viewModel.getNoteDetailsForId(id: noteId) {
                if self.viewModel.unauthorized {
                    // If we cannot refresh, pop off back to login
                    self.rootIsActive = false
                }
            }
            self.userViewModel.getUserInformation() {
                if self.userViewModel.unauthorized {
                    // If we cannot refresh, pop off back to login
                    self.rootIsActive = false
                }
                if self.userViewModel.error {
                    // Unknown error getting user data -- logout user
                    
                    self.userViewModel.performLogout()
                    if (self.userViewModel.logout) {
                        self.rootIsActive = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
    }
}

struct PDFKitView: View {
    var data: Data
    
    var body: some View {
        PDFKitRepresentedView(data)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.displaysAsBook = true
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view (leave this empty ... this is read-only)
    }
}

//Custom Half sheet modifier
extension View{
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView, onEnd: @escaping ()->()) -> some View{
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable{
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if showSheet{
            
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        }
        else{
            uiViewController.dismiss(animated: true)
        }
        
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate{
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper){
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
    
}

struct CloudNoteView_Previews: PreviewProvider {
    @Binding var isNavigationBarHidden: Bool
    init(isNavigationBarHidden: Binding<Bool>) {
        _isNavigationBarHidden = .constant(false)
    }
    static var previews: some View{
        Group {
            DetailedNoteView(rootIsActive: .constant(true), noteId: 9)
            DetailedNoteView(rootIsActive: .constant(true), noteId: 9)
                .preferredColorScheme(.dark)
            
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        
        //view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController{
            presentationController.detents = [
                .medium(),
                .large()
            ]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}
