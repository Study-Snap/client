//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI
import MobileCoreServices


struct NoteSearchView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel : NoteSearchViewModel = NoteSearchViewModel()
    @StateObject var deleteClassroomViewModel: DeleteClassroomViewModel = DeleteClassroomViewModel()
    @StateObject var classroomViewModel: ClassroomViewViewModel = ClassroomViewViewModel()
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

    

    var body: some View {
        
        ZStack(alignment: .center) {
            
            
            NavigationView {
                VStack {
                    
                    VStack {
                        NavigationLink(
                            destination: CloudNoteView(rootIsActive: self.$rootIsActive, noteId: self.targetNoteId!)   .navigationBarBackButtonHidden(true) ,
                            isActive: $showNoteDetails,
                            label: {
                                EmptyView()
                                
                            }).isDetailLink(false)
                        
                    }
                    if deleteClassroomViewModel.loading {
                        
                        ProgressView("Loading classrooms")
                            .foregroundColor(Color("Secondary"))
                        
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
                            SearchBar(viewModel: viewModel, text: $searchText, classID: classID)
                                .padding(.horizontal)
                            if searchText.isEmpty
                                {
                                    if viewModel.trending.count > 0 {
                                        Text("Top Rated Notes").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                                            .padding(.top, 3)
                                        ScrollView{
                                            LazyVStack {
                                                VStack {
                                                    ForEach(viewModel.trending) { item in
                                                        
                                                        NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, rating: item.rating!)
                                                            .onTapGesture {
                                                                self.targetNoteId = item.id!
                                                                self.showNoteDetails.toggle()
                                                            }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        VStack(alignment: .center) {
                                            Spacer()
                                            Image(systemName: "questionmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("AccentDark"))
                                                .frame(width: 100, height: 100, alignment: .center)
                                                .padding()
                                            Text("No notes to show. Try searching for some!")
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
                                        ScrollView{
                                            LazyVStack {
                                                VStack {
                                                    ForEach(viewModel.results) { item in
                                                        
                                                        NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, rating: item.rating!)
                                                            .onTapGesture {
                                                                self.showNoteDetails.toggle()
                                                                self.targetNoteId = item.id!
                                                            }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        VStack(alignment: .center) {
                                            Spacer()
                                            Image(systemName: "questionmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("AccentDark"))
                                                .frame(width: 100, height: 100, alignment: .center)
                                                .padding()
                                            Text("No notes to show. Try searching for some!")
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
                    
                }  .onAppear(perform: {
                    self.viewModel.getTopTrendingNotes(currentClassId: self.classID)
                })
                
                    .navigationBarTitle(className, displayMode: .inline)
                .toolbar {
                    
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
                                NoteUploadView(rootIsActive: self.$rootIsActive, classRoomId: classID)
                            }
                            
                            if self.deleteClassroomViewModel.currentUser == self.deleteClassroomViewModel.classroomOwner{
                                
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
                                        self.classroomViewModel.leaveClassroomResponse(classId: classID)
                                        self.isConfirmedLeavingClassroom = true
                                        self.classID = ""
                                    }
                                } message:{
                                    Text("Are you sure you want to delete the classroom? All data inside will be deleted")
                                }
                                NavigationLink(
                                    destination: ClassroomsView(rootIsActive: self.$rootIsActive)
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true),
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
                                        self.classroomViewModel.leaveClassroomResponse(classId: classID)
                                        self.isConfirmedLeavingClassroom = true
                                    }
                                } message:{
                                    Text("Are you sure you want to leave the classroom?")
                                }
                                NavigationLink(
                                    destination: ClassroomsView(rootIsActive: self.$rootIsActive)
                                        .navigationBarTitle("")
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true)
                                        .accentColor(.black),
                                    isActive: $isConfirmedLeavingClassroom
                                ) {
                                    EmptyView() // Button follows
                                }.isDetailLink(false)
                            }
                            
                            
                            
                        } //: HSTACK
                    } //: BUTTONS
                }
            }//: TOOLBAR
        }.onAppear(perform: {
            
            self.deleteClassroomViewModel.getUser()
            self.deleteClassroomViewModel.getClassroom(classId: classID)
            
        })
        
        
    }
}
    
    struct SearchBar: UIViewRepresentable {
        @StateObject var viewModel: NoteSearchViewModel
        @Binding var text: String
        @State var classID: String
        
        class Coordinator: NSObject, UISearchBarDelegate {
            @StateObject var viewModel: NoteSearchViewModel
            @Binding var text: String
            @State var classID: String
            init(text: Binding<String>, viewModel: StateObject<NoteSearchViewModel>, classID: State<String>) {
                _text = text
                _viewModel = viewModel
                _classID = classID
            }
            
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                text = searchText
            }
            
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                self.viewModel.search(searchQuery: text, currentClassId: classID)
                searchBar.endEditing(true)
            }
        }
        
        func makeCoordinator() -> SearchBar.Coordinator {
            return Coordinator(text: $text, viewModel: _viewModel ,classID: _classID)
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
            NoteSearchView(rootIsActive: .constant(true), classID: "448f7db0-e3ac", className: "Biology 505")
                .previewDevice("iPhone 11 Pro")
        }
    }

