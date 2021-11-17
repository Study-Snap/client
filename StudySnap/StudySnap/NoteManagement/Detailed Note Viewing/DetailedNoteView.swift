//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI
import SwiftyBibtex

struct DetailedNoteView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let noteId: Int
    
    // View model
    @StateObject var viewModel: DetailedNoteViewViewModel = DetailedNoteViewViewModel()
    
    // Alert value
    @State private var showCitation = false
    // Setup citation
    @State private var citationAuthor = ""
    @State private var citationTitle = ""
    @State private var citationYear = ""
    
    var body: some View {
      
            VStack {
                if false {
                    ProgressView("Loading note details...")
                        .foregroundColor(Color("Secondary"))
                } else {
                    VStack {
                        // MARK: Top (title, author, rating and keywords)
                        VStack {
                            ZStack {
                                Color("Primary")
                                VStack {
                                    Text(viewModel.noteObj.title!)
                                        .font(.title)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                    Text("\(viewModel.noteObj.user!.firstName) \(viewModel.noteObj.user!.lastName)")
                                        .font(.title2)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                        .padding(.top, -20)
                                    HStack(alignment: .center) {
                                        ForEach(0..<3) { i in
                                            let keywords = viewModel.noteObj.keywords!
                                            if keywords.count > i {
                                                
                                                Text(keywords[i])
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 20)
                                                    .foregroundColor(.black.opacity(0.8))
                                                    .background(Color(.white))
                                                    .cornerRadius(7.0)
                                            }
                                        }
                                    }
                                    .padding(.top, 5)
                                    VStack {
                                        NoteRatingView()
                                    }.padding(.top, 5.0)
                                }
                            }
                            .cornerRadius(15.0)
                        }.edgesIgnoringSafeArea([.top])
                        
                        
                        VStack(alignment: .leading) {
                            // MARK: Note Download Button
                            HStack {
                                Button(action: {print("Test")}, label: {
                                    Text("Get Full Note").foregroundColor(Color("Secondary")).padding()
                                })
                                Spacer()
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title3)
                                    .foregroundColor(Color("Secondary"))
                                    .padding(.horizontal)
                            }
                            .padding(.horizontal, 10)
                            .background(Color("Accent"))
                            .cornerRadius(7.0)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            
                            // MARK: Main Content
                            ScrollView {
                                VStack(alignment: .leading){
                                    VStack(alignment: .leading) {
                                        Text("DESCRIPTION")
                                            .font(.caption)
                                            .foregroundColor(Color("Primary"))
                                            .padding(.bottom, 0)
                                        
                                        Text(viewModel.noteObj.shortDescription!).font(.caption).fontWeight(.light)
                                    }
                                    .padding()
                                    
                                    VStack(alignment: .leading) {
                                        Text("ABSTRACT") // MARK: Spacing between title and content exists due to extra new line characters within the note body variable
                                            .font(.caption)
                                            .foregroundColor(Color("Primary"))
                                        
                                        Text(viewModel.noteObj.noteAbstract!).font(.caption).fontWeight(.light).multilineTextAlignment(.leading)
                                    }.padding()
                                    
                                }
                            }
                            .frame(width: .infinity, height: .infinity, alignment: .leading)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            Spacer()
                            // MARK: Bottom buttons
                            HStack {
                                HStack {
                                    Text("\(viewModel.noteObj.timeLength!) Minute Read").foregroundColor(Color("Secondary")).padding(.vertical, 10).padding(.horizontal, 25)
                                }
                                .padding(.horizontal, 10)
                                .background(Color("Accent"))
                                .cornerRadius(7.0)
                                .padding(.horizontal)
                                
                                HStack {
                                    Button(action: {
                                        if (viewModel.noteObj.bibtextCitation! != "") {
                                            do {
                                                let result = try SwiftyBibtex.parse(viewModel.noteObj.bibtextCitation!)
                                                citationAuthor = result.publications[0].fields["author"]!
                                                citationTitle = result.publications[0].fields["title"]!
                                                citationYear = result.publications[0].fields["year"]!
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
                                        Text("Cite Me").accentColor(Color("Secondary")).padding(.vertical, 10).padding(.horizontal, 20)
                                    }).sheet(isPresented: $showCitation) {
                                        CitationView(citationAuthor: $citationAuthor, citationTitle: $citationTitle, citationYear: $citationYear)
                                    }
                                }
                                .padding(.horizontal, 10)
                                .background(Color("Accent"))
                                .cornerRadius(7.0)
                                .padding(.horizontal)
                            }
                        }
                    }.toolbar{
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
                    }
                }
            }.onAppear(perform: {
                self.viewModel.getNoteDetailsForId(id: noteId) {
                    if self.viewModel.unauthorized {
                        // If we cannot refresh, pop off back to login
                        self.rootIsActive = false
                    }
                }
            })
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
