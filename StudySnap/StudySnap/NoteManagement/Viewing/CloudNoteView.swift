//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct CloudNoteView: View {
    @Binding var rootIsActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let noteId: Int
    
    // View model
    @StateObject var viewModel: NoteViewViewModel = NoteViewViewModel()
    
    var body: some View {
      
            VStack {
                if viewModel.loading {
                    ProgressView("Loading note details...")
                        .foregroundColor(Color("Secondary"))
                } else {
                    VStack {
                        VStack {
                            ZStack {
                                Color("Primary")
                                VStack {
                                   
                                    Text(viewModel.noteObj.title!)
                                        .font(.title)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(20)
                                        .padding(.top, 25)
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
                                                    .foregroundColor(Color("Secondary"))
                                                    .background(Color(.white))
                                                    .cornerRadius(7.0)
                                                
                                            }
                                        }
                                    }
                                    .padding(.top, 25)
                                    VStack {
                                        NoteRatingView(avgRating: calculateRating(ratings: viewModel.noteObj.rating!), starFilledColor: .yellow, starEmptyColor: .white)
                                    }.padding(.top, 15)
                                }
                            }
                     
                            .cornerRadius(15.0)
                        }.edgesIgnoringSafeArea([.top])
                        
                        
                        VStack {
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
                            .padding(.bottom, 15)
                            
                            // MARK: Main Content
                            ScrollView {
                                VStack(alignment: .leading){
                                    VStack(alignment: .leading) {
                                        Text("DESCRIPTION")
                                            .font(.caption)
                                            .foregroundColor(Color("Primary"))
                                            .padding(.bottom, 0)
                                        
                                        Text(viewModel.noteObj.shortDescription!).fontWeight(.light)
                                    }
                                    .padding()
                                    
                                    VStack(alignment: .leading) {
                                        Text("DETAILS") // MARK: Spacing between title and content exists due to extra new line characters within the note body variable
                                            .font(.caption)
                                            .foregroundColor(Color("Primary"))
                                        
                                        Text(viewModel.noteObj.body!).fontWeight(.light)
                                    }.padding()
                                    
                                }
                            }
                            .frame(width: .infinity, height: .infinity, alignment: .leading)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            Spacer()
                            // MARK: Bottom buttons
                            HStack {
                                Text("About a \(viewModel.noteObj.timeLength!) minute read: ")
                                Button(action: {print("Cited!")}, label: {
                                    Text("Cite Note")
                                        .accentColor(Color("Primary"))
                                    
                                })
                                
                                
                            }.padding()
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
        CloudNoteView(rootIsActive: .constant(true), noteId: 9)
    }
}
