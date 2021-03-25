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
    var fruits: [Fruit] = fruitsData

    var body: some View {
        
        TabView {
            
            VStack {
                //Search
                Text("Search").font(.custom("Inter Semi Bold", size: 30)).multilineTextAlignment(.center)
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                NavigationView {
                    
                    VStack {
                        MiniNoteCardView()
                            .frame(height: 280)
                          .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .cornerRadius(20)
                            .padding(.horizontal,25)
                            
                        
                        List {

     
                            ForEach(self.cars.filter {
                                self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                            }, id: \.self) { car in
                                Text(car)
                            }
                        }
                        
                    }.navigationTitle("We Recommend")
                    
                    
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
        ContentView(fruits: fruitsData)
    }
}
