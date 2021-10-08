//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI
import MobileCoreServices

struct NoteSearchView: View {
    @StateObject var viewModel : NoteSearchViewModel = NoteSearchViewModel()
    @State private var searchText : String = ""
    @State var showNoteDetails: Bool = false
    @State var isUploadingNotes: Bool = false
    @State var targetNoteId: Int? = 1
    @State var classID: String //Value recived as a parameter from the classroom view
    @State var className: String
    var body: some View {

        NavigationView {
            VStack {
                    VStack {
                    NavigationLink(
                        destination: CloudNoteView(noteId: self.targetNoteId!),
                        isActive: $showNoteDetails,
                        label: {
                            EmptyView()
                                .accentColor(.white)
                        })
                            .foregroundColor(Color(.systemBlue))
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
                        VStack(alignment: .leading) {
                            if viewModel.trending.count > 0 {
                                Text("Top picks by the community").font(.title3).fontWeight(.medium).foregroundColor(Color("Secondary"))
                                
                                MiniNoteCardView(notes: self.viewModel.trending, onClick: {noteId in
                                    // Trigger navigation to the note
                                    self.targetNoteId = noteId
                                    self.showNoteDetails.toggle()
                                })
                                .cornerRadius(20)
                                .frame(height: 150, alignment: .center)
                            } else {
                                // No top notes available
                                EmptyView()
                            }
                        }
                        .padding()
                        .onAppear(perform: {
                            self.viewModel.getTopTrendingNotes(currentClassId: classID)
                        
                        })
                        VStack(alignment: .leading) {
                            if viewModel.results.count > 0 {
                                Text("We found these").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                                    .padding(.top, 3)
                                ScrollView{
                                    LazyVStack {
                                        VStack {
                                            ForEach(viewModel.results) { item in
                                                NoteListRowItem(id: item.id!, title: item.title!, author: String("Author Name"), shortDescription: item.shortDescription!, readTime: 5, rating: item.rating!, onClick:
                                                { noteId in
                                                    // trigger navigation
                                                    self.targetNoteId = noteId
                                                    self.showNoteDetails.toggle()
                                                })
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
                        .cornerRadius(12)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack(spacing: 16) {
                                    Button(action: {
                                      isUploadingNotes = true
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.body)
                                            .foregroundColor(Color("Secondary"))
                                    } //: BUTTON
                                    .sheet(isPresented: $isUploadingNotes) {
                                        NoteUploadView(classRoomId: classID)
                                    }
                                } //: HSTACK
                            } //: BUTTONS
                        }//.background(Color(.systemGray6)) //: TOOLBAR
                        .navigationBarTitle(className, displayMode: .inline)
                        
                        
                    }
                    .alert(isPresented: $viewModel.error, content: {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: Alert.Button.cancel(Text("Okay")))
                    })

            }
        }.accentColor(.white)
           
            

       
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
        NoteSearchView(classID: "448f7db0-e3ac", className: "Biology 505")
            .previewDevice("iPhone 11 Pro")
    }
}
