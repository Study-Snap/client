//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI


struct NoteSearchView: View {
    @StateObject var viewModel : NoteSearchViewModel = NoteSearchViewModel()
    @State private var searchText : String = ""
    @State var showNoteDetails: Bool = false
    @State var targetNoteId: Int? = 1
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                NavigationLink(
                    destination: CloudNoteView(noteId: self.targetNoteId!),
                    isActive: $showNoteDetails,
                    label: {
                        EmptyView()
                    })
                }
                VStack() {
                    SearchBar(viewModel: viewModel, text: $searchText)
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
                        self.viewModel.getTopTrendingNotes()
                    })
                    VStack(alignment: .leading) {
                        if viewModel.results.count > 0 {
                            Text("We found these").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                            ScrollView{
                                LazyVStack {
                                    VStack {
                                        ForEach(viewModel.results) { item in
                                            NoteListRowItem(id: item.id!, title: item.title!, author: String("Liam Stickney"), shortDescription: item.shortDescription!, readTime: 5, rating: item.rating!, onClick:
                                            { noteId in
                                                // trigger navigation
                                                self.targetNoteId = noteId
                                                self.showNoteDetails.toggle()
                                            })
                                        }.padding(5)
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
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                .navigationTitle("Search")
                .alert(isPresented: $viewModel.error, content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: Alert.Button.cancel(Text("Okay")))
                })

            }.navigationViewStyle(StackNavigationViewStyle())
        }.accentColor(.white)
    }
}


struct SearchBar: UIViewRepresentable {
    @StateObject var viewModel: NoteSearchViewModel
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @StateObject var viewModel: NoteSearchViewModel
        @Binding var text: String

        init(text: Binding<String>, viewModel: StateObject<NoteSearchViewModel>) {
            _text = text
            _viewModel = viewModel
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.viewModel.search(searchQuery: text)
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, viewModel: _viewModel)
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
        NoteSearchView()
    }
}
