//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI
import MobileCoreServices


struct ClassroomDetailView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel : ClassroomDetailViewViewModel = ClassroomDetailViewViewModel()
    @StateObject var classroomViewModel: ClassroomDashboardViewModel = ClassroomDashboardViewModel()
    @StateObject var ratingViewModel : NoteRatingViewModel = NoteRatingViewModel()
    @Binding var hasLeftClassroom: Bool //Used to determine if a user has left a classroom
    @State var displayResults : [ApiNoteResponse] = []
    @State private var searchText : String = ""
    @State var showNoteDetails: Bool = false
    @State var isUploadingNotes: Bool = false
    @State var isLeavingClassroom: Bool = false
    @State var isConfirmedLeavingClassroom: Bool = false
    @State var error: Bool = false
    @State var errorMessage: String?
    @State var targetNoteId: Int? = 1
    @State var classID: String //Value recived as a parameter from the classroom view
    @State var className: String
    @State var refresh: Bool = false
    @State var isRatingDisabled: Bool = true
    @State var isNoteUpdated: Bool = false
  

    var body: some View {
    
        ZStack(alignment: .center) {
            NavigationView {
                VStack {
                    
                    VStack {
                        NavigationLink(
                            destination: DetailedNoteView(rootIsActive: self.$rootIsActive, isNoteUpdated: self.$isNoteUpdated, noteId: self.targetNoteId!)   .navigationBarBackButtonHidden(true) ,
                            isActive: $showNoteDetails,
                            label: {
                                EmptyView()
                                
                            }).isDetailLink(false)
                        
                    }
                    VStack{
                            
                            HStack {
                                
                                Image(systemName: "doc.on.clipboard")
                                Text(classID)
                                    .bold()
                                    .font(.caption)
                                    .frame(width: .infinity, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 7).foregroundColor(Color(.systemGray5)).shadow(color: .black, radius: 2, x: 0, y: 1))
                                    .contextMenu {
                                        Button(action: {
                                            UIPasteboard.general.string = classID
                                        }) {
                                            Text("Copy to clipboard")
                                            Image(systemName: "doc.on.clipboard")
                                        }
                                    }
                                
                            }
                        SearchBar(rootIsActive: self.$rootIsActive, viewModel: viewModel, text: $searchText, classID: classID)
                                .padding(.horizontal)
                            if searchText.isEmpty
                                {
                                    if viewModel.trending.count > 0 {
                                        Text("Top Rated Notes").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                                            .padding(.top, 3)
                                        List {
                                            ForEach(viewModel.trending) { item in
                                                NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, ratings: item.ratings!, rootIsActive: self.$rootIsActive, isRatingDisabled: $isRatingDisabled, isNoteUpdated: self.$isNoteUpdated)
                                                    .onTapGesture {
                                                        self.targetNoteId = item.id!
                                                        self.showNoteDetails.toggle()
                                                    }.padding(.vertical, 15)
                                            }
                                        }
                                        .listStyle(.plain)
                                        .cornerRadius(radius: 12, corners: [.topLeft,.topRight])
                                    } else {
                                        VStack(alignment: .center) {
                                            Spacer()
                                            Image(systemName: "questionmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("AccentDark"))
                                                .frame(width: 100, height: 100, alignment: .center)
                                                .padding()
                                            Text("No notes to show. Be the first to upload one!")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("AccentDark"))
                                            Spacer()
                                            Spacer()
                                        }
                                        .cornerRadius(12)
                                    }
                                
                            }else{
                                    if viewModel.results.count > 0 {
                                        Text("We found these").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                                            .padding(.top, 3)
                                        List {
                                            ForEach(viewModel.results) { item in
                                                
                                                NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, ratings: item.ratings!, rootIsActive: self.$rootIsActive, isRatingDisabled: $isRatingDisabled, isNoteUpdated: self.$isNoteUpdated)
                                                    .onTapGesture {
                                                        self.targetNoteId = item.id!
                                                        self.showNoteDetails.toggle()
                                                    }.padding(.vertical, 10)
                                  
                                 
                                            }
                                        }.listStyle(.plain)
                                    } else {
                                        VStack(alignment: .center) {
                                            Spacer()
                                            Image(systemName: "questionmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("AccentDark"))
                                                .frame(width: 100, height: 100, alignment: .center)
                                                .padding()
                                            Text("Couldn't find anything. Try another query!")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("AccentDark"))
                                            Spacer()
                                            Spacer()
                                        }
                                        .cornerRadius(12)
                                    }
                                }
                            
                        
                    }
                    .alert(isPresented: $viewModel.error, content: {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: Alert.Button.cancel(Text("Okay")))
                    })
                    
                }
                .onChange(of: refresh || isNoteUpdated) { value in
                    if self.refresh || self.isNoteUpdated{
                            // Refresh top notes
                            self.viewModel.getTopTrendingNotes(currentClassId: self.classID) {
                                if self.viewModel.unauthorized {
                                    // Refresh failed, return to login
                                    self.rootIsActive = false
                                }
                            }
                            // Reset flag
                            self.isNoteUpdated = false
                            self.refresh = false
                        }
                    }
                
                    .navigationBarTitle(className, displayMode: .inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack(spacing: 5) {
                            Button(action: {
                               self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color("PrimaryText"))
                            }
                        
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 5) {
                            
                            Button(action: {
                                isUploadingNotes = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.body)
                                    .foregroundColor(Color("Secondary"))
                            } //: BUTTON
                            .sheet(isPresented: $isUploadingNotes) {
                                NoteUploadView(rootIsActive: self.$rootIsActive, refreshClassroom: self.$refresh, classRoomId: classID)
                            }
                            
                            if self.classroomViewModel.currentUser == self.classroomViewModel.classroomOwner{
                                
                                Button(action: {
                                    isLeavingClassroom = true
                                   
                                }){
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .accentColor(Color(.systemRed))
                                        .font(.body)
                                    
                                }
                                .alert("Delete Classroom Confirmation", isPresented: $isLeavingClassroom) {
                                    Button("Cancel", role: .cancel){
                                        self.isConfirmedLeavingClassroom = false
                                    }
                                    Button("Delete", role: .destructive){
                                        self.classroomViewModel.leaveClassroomResponse(classId: classID) {
                                            if self.classroomViewModel.unauthorized {
                                                // Refresh failed, return to login
                                                self.rootIsActive = false
                                            } else {
                                                self.classID = ""
                                                self.hasLeftClassroom = true
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                } message:{
                                    Text("Are you sure you want to delete the classroom? All data inside will be deleted")
                                }
                                NavigationLink(
                                    destination: ClassroomsDashboard(rootIsActive: self.$rootIsActive),
                                    isActive: $isConfirmedLeavingClassroom
                                ) {
                                    EmptyView() // Button follows
                                }
                                .isDetailLink(false)
                            }else{
                                
                                Button(action: {
                                    isLeavingClassroom = true
                                    
                                }){
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .accentColor(Color(.systemRed))
                                        .font(.body)
                                    
                                }
                                .alert("Leave Confirmation", isPresented: $isLeavingClassroom) {
                                    Button("Cancel", role: .cancel){
                                        self.isConfirmedLeavingClassroom = false
                                    }
                                    Button("Leave", role: .destructive){
                                        self.classroomViewModel.leaveClassroomResponse(classId: classID) {
                                            if self.classroomViewModel.unauthorized {
                                                // Refresh failed, return to login
                                                self.rootIsActive = false
                                            } else {
                                                self.hasLeftClassroom = true
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                } message:{
                                    Text("Are you sure you want to leave the classroom?")
                                }
                                NavigationLink(
                                    destination: ClassroomsDashboard(rootIsActive: self.$rootIsActive),
                                    isActive: $isConfirmedLeavingClassroom
                                ) {
                                    EmptyView() // Button follows
                                }
                            }
                        } //: HSTACK
                    } //: BUTTONS
                }
            }//: TOOLBAR
        }.onAppear(perform: {
            self.classroomViewModel.getUser() {
                if self.viewModel.unauthorized {
                    // Refresh failed, return to login
                    self.rootIsActive = false
                }
                
                self.classroomViewModel.getClassroom(classId: self.classID) {
                    if self.viewModel.unauthorized {
                        // Refresh failed, return to login
                        self.rootIsActive = false
                    }
                    
                    self.viewModel.getTopTrendingNotes(currentClassId: self.classID) {
                        if self.viewModel.unauthorized {
                            // Refresh failed, return to login
                            self.rootIsActive = false
                        }
                    }
                }
            }
        })
    }
}

    struct SearchBar: UIViewRepresentable {
        @Binding var rootIsActive: Bool
        @StateObject var viewModel: ClassroomDetailViewViewModel
        @Binding var text: String
        @State var classID: String
        
        class Coordinator: NSObject, UISearchBarDelegate {
            @StateObject var viewModel: ClassroomDetailViewViewModel
            @Binding var rootIsActive: Bool
            @Binding var text: String
            @State var classID: String
            init(rootIsActive: Binding<Bool>, text: Binding<String>, viewModel: StateObject<ClassroomDetailViewViewModel>, classID: State<String>) {
                _text = text
                _viewModel = viewModel
                _classID = classID
                _rootIsActive = rootIsActive
            }
            
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                text = searchText
            }
            
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                self.viewModel.search(searchQuery: text, currentClassId: classID) {
                    if self.viewModel.unauthorized {
                        // Refresh failed, return to login
                        self.rootIsActive = false
                    }
                    
                    searchBar.endEditing(true)
                }
            }
        }
        
        func makeCoordinator() -> SearchBar.Coordinator {
            return Coordinator(rootIsActive: self.$rootIsActive, text: $text, viewModel: _viewModel ,classID: _classID)
        }
        
        func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
            let searchBar = UISearchBar(frame: .zero)
            searchBar.delegate = context.coordinator
            searchBar.searchBarStyle = .minimal
            return searchBar
        }
        
        func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
            uiView.text = text
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                ClassroomDetailView(rootIsActive: .constant(true), hasLeftClassroom: .constant(true), classID: "448f7db0-e3ac", className: "Biology 505")
                    .previewDevice("iPhone 11 Pro")
                ClassroomDetailView(rootIsActive: .constant(true), hasLeftClassroom: .constant(true), classID: "448f7db0-e3ac", className: "Biology 505")
                    .previewDevice("iPhone 11 Pro")
                    .preferredColorScheme(.dark)
                    .previewInterfaceOrientation(.portrait)
            }
        }
        
    }

