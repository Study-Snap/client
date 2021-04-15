//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI


struct NoteSearchView: View {
    @StateObject var viewModel : NoteSearchViewModel = NoteSearchViewModel()
    @State private var searchText : String = "Search for notes"
    
    var body: some View {
        NavigationView {
            VStack() {
                SearchBar(viewModel: viewModel, text: $searchText)
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Recommended").font(.title).fontWeight(.medium).foregroundColor(Color("Secondary"))
                    
                    MiniNoteCardView()
                        .cornerRadius(20)
                        .frame(height: 150, alignment: .center)
                }.padding()
                VStack(alignment: .leading) {
                    if viewModel.results.count > 0 {
                        Text("Other stuff we found").font(.title2).fontWeight(.medium).foregroundColor(Color("Secondary"))
                        ScrollView{
                            LazyVStack {
                                VStack {
                                    ForEach(viewModel.results) { item in
                                        NoteListRowItem(title: item.title!, author: String("Liam Stickney"), shortDescription: item.shortDescription!, readTime: 5, rating: item.rating!)
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
                            Text("We couldn't find anything else")
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
