//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI


struct ContentView: View {
    @State private var searchText : String = ""
    @ObservedObject var globalJsonData = GlobalString()
    
    var body: some View {
        let notes = globalJsonData.notesData
        
                NavigationView {
                    
                    VStack {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                        MiniNoteCardView()
                            .cornerRadius(20)
            
                        List(notes.filter({searchText.isEmpty ? true : $0.title.contains(searchText)})){
                            item in
                            
                            NavigationLink(destination:{
                                VStack{
                                    if item.isOnline{
                                        CloudNoteView(note: item)
                                    }else{
                                        LocalNoteView(note: item)
                                    }
                                }
                            }()) {
                                Text(item.title).cornerRadius(20)
                            }
                        }.listStyle(InsetGroupedListStyle())
                  
                        
                    }.navigationTitle("Search")
       
                }.navigationViewStyle(StackNavigationViewStyle())

    }
    
}


struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
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
        ContentView()
    }
}
