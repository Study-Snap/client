//
//  ContentView.swift
//  StudySnap
//
//  Created by The lads on 2021-03-04.
//

import SwiftUI


struct ContentView: View {
    @State private var searchText : String = ""
    let cars = ["Subaru WRX", "Tesla Model 3", "Porsche 911", "Renault Zoe", "DeLorean", "Mitsubishi Lancer", "Audi RS6"]


    var body: some View {
        VStack {
            //Search
            Text("Search").font(.custom("Inter Semi Bold", size: 30)).multilineTextAlignment(.center)
            SearchBar(text: $searchText)
                .padding(.horizontal)
            NavigationView {
                
                VStack {
                    
                    List {
                        MiniNoteCardView()
                            .frame(height: 300)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                            .padding(.vertical)
                            
                        
                        ForEach(self.cars.filter {
                            self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                        }, id: \.self) { car in
                            Text(car)
                        }
                    }
                    
                }.navigationTitle("We Recommend")
                
                
            }.frame(minWidth: 0/*@END_MENU_TOKEN@*/, idealWidth: 100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: /*@START_MENU_TOKEN@*/.center)
            
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
