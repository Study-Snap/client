//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI


struct ContentView: View {
    @State private var searchText : String = ""
    @ObservedObject var globalString = GlobalString()
    var body: some View {
        let notes = globalString.notesData
        TabView {
            
            VStack {
                //Search

                NavigationView {
                    
                    VStack {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                        MiniNoteCardView()
                            .cornerRadius(20)
                            .padding(.horizontal,25)
                            .tabViewStyle(PageTabViewStyle())
                        
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
                
                        
                            
                

//                        List {
//                            ForEach(globalString.notesData){ item in
//                                if (self.searchText.isEmpty){
//                                    noteTitleRow(note: item)
//                                }else{
//                                    List(todoItems.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
//                                        Text(item.name)
//                                    }
//                                }

//                                self.searchText.isEmpty ? true : item.title.lowercased().contains(self.searchText.lowercased())
//                                    noteTitleRow(note: item)
                                
                        
     
//                            ForEach(globalString.notesData) {
//                                self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
//                            }, id: \.self) { car in
//                                Text(car)
//                            }
                        
                        
                    }.navigationTitle("Search")
                    
                    
                }
                
            }
        }
    }
    
}

/*struct AppLogo: View {
    var body: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    Image("Logo").padding().offset(y: -200)
                }
            }
        }
    }
}

struct BtnGetStarted: View {
    var body: some View {
        NavigationView {
            self.navigationTitle("")
                .navigationBarHidden(true)
            NavigationLink(destination: SignUpView().navigationBarHidden(true).navigationTitle("")) {
                EmptyView()
            }
        }
    }
}
*/
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
