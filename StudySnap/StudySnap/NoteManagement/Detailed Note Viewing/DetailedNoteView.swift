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
    @StateObject var ratingViewModel: NoteRatingViewModel = NoteRatingViewModel()
    
    // Alert value
    @State private var showCitation = false
    // Setup citation
    @State private var citationAuthor = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var citationTitle = ""
    @State private var citationYear = ""
    @State var isRatingDsiabled = false
    @State var selectedNoteRating = -1
    @State var currentNote: Int = 1
    
    var body: some View {
      
            VStack {
                if viewModel.loading {
                    ProgressView("Loading note details...")
                        .foregroundColor(Color("Secondary"))
                } else {
                    VStack {
                        // MARK: Top (title, author, rating and keywords)
                        VStack {
                            ZStack {
                                Color("Primary").frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 240)
                                VStack {
                                    Text(viewModel.noteObj.title!)
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: 300)
                                        .padding(.top, 25)
                                    Text("\(viewModel.noteObj.user!.firstName) \(viewModel.noteObj.user!.lastName)")
                                        .font(.headline)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                    VStack {
                                        NoteRatingView(isDisabled: $isRatingDsiabled, selected: $selectedNoteRating, currentNote: self.viewModel.noteObj.id!)
                                            .onChange(of: self.selectedNoteRating) { value in
                                                self.ratingViewModel.putRating(ratingValue: self.selectedNoteRating, currentNoteId: viewModel.noteObj.id!){
                                                    if self.ratingViewModel.unauthorized {
                                                        // Refresh failed, return to login
                                                        self.rootIsActive = false
                                                    }
                                                }
                                            }

                                                //self.viewModel.loading = true
                  
                                            
                                    }.padding(.vertical, 10)
                                    HStack(alignment: .center) {
                                        ForEach(0..<3) { i in
                                            let keywords = viewModel.noteObj.keywords!
                                            if keywords.count > i {
                                                
                                                Text(keywords[i])
                                                    .padding(.vertical, 5)
                                                    .padding(.horizontal, 10)
                                                    .foregroundColor(.black.opacity(0.8))
                                                    .background(Color(.white))
                                                    .cornerRadius(7.0)
                                            }
                                        }
                                    }
                                }.padding(.top)
                            }
                            .edgesIgnoringSafeArea(.top)
                        }.edgesIgnoringSafeArea(.top)
                        
                        
                        VStack(alignment: .leading) {
                            // MARK: Note Download Button
                            HStack {
                                Button(action: {print("Test")}, label: {
                                    Text("Get Full Note").foregroundColor(Color("Secondary")).padding()
                                    Spacer()
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.title3)
                                        .foregroundColor(Color("Secondary"))
                                        .padding(.horizontal)
                                })

                            }

                            .background(Color("Accent"))
                            .cornerRadius(radius: 12, corners: [.bottomLeft, .bottomRight])
                            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                            .strokeStyle()
                            
                            
                            // MARK: Main Content
                            ScrollView {
                                VStack(alignment: .leading){
                                    VStack(alignment: .leading) {
                                        Text("DESCRIPTION")
                                            .font(.caption)
                                            .foregroundColor(Color("Primary"))
                                        
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
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(12)
                            
                            Spacer()
                            
                            // MARK: Bottom buttons
                            HStack(spacing: 1.0) {
                                HStack {
                                    Text("\(viewModel.noteObj.timeLength!) Minute Read").foregroundColor(Color("Secondary")).padding(.vertical, 15)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color("Accent"))
                                .cornerRadius(radius: 12, corners: [.topLeft, .bottomLeft])
                           

                                HStack {
                                    Button(action: {
                                        if (viewModel.noteObj.bibtextCitation! != "") {
                                            do {
                                                let result = try SwiftyBibtex.parse(viewModel.noteObj.bibtextCitation!)
                                                citationAuthor = result.publications[0].fields["author"]!
                                                citationTitle = result.publications[0].fields["title"]!
                                                citationYear = result.publications[0].fields["year"]!
                                                let aBreakdown = citationAuthor.components(separatedBy: " and ")
                                                if aBreakdown.count != 2 {
                                                    firstName = ""
                                                    lastName = ""
                                                } else {
                                                    firstName = aBreakdown[0]
                                                    lastName = aBreakdown[1]
                                                }
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
                                        Text("Cite Me").accentColor(Color("Secondary")).padding(.vertical, 15)
                                    }).sheet(isPresented: $showCitation) {
                                        CitationView(citation: Citation(authorFirstName: firstName, authorLastName: lastName, publishYear: Int(citationYear) ?? 1998, publishTitle: citationTitle))
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(Color("Accent"))
                                .cornerRadius(radius: 12, corners: [.topRight, .bottomRight])
                                .shadow(color: Color("Shadow").opacity(0.15), radius: 10, x:10, y: 2)
                                
                              
                                
                               
                            }
                            .padding(.horizontal)
                        }.offset(x: 0, y: -5)
                    }.edgesIgnoringSafeArea(.top).toolbar{
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
