//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct CloudNoteView: View {
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
                                Text("Liam Stickney")
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
                        .frame(height: 340, alignment: .center)
                        .cornerRadius(15.0)
                    }
                    .ignoresSafeArea()
                    
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
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("DESCRIPTION")
                                        .font(.caption)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.bottom, 0)
                                    
                                    Text(viewModel.noteObj.shortDescription!).fontWeight(.light)
                                }.padding()
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("DETAILS")
                                        .font(.caption)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.bottom, 0)
                                    
                                    Text(viewModel.noteObj.body!).fontWeight(.light)
                                }.padding()
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        // MARK: Bottom buttons
                        HStack {
                            Text("About a \(viewModel.noteObj.timeLength!) minute read")
                                .foregroundColor(Color("Secondary"))
                                .padding(.horizontal, 45)
                                .padding(.vertical)
                                .background(Color("Accent"))
                            Button(action: {print("Cited!")}, label: {
                                Text("Cite Note")
                            })
                            .foregroundColor(Color("Secondary"))
                            .padding()
                            .background(Color("Accent"))
                        }.padding()
                    }.padding(.top, -125)
                }
            }
        }
        .onAppear(perform: {
            self.viewModel.getNoteDetailsForId(id: noteId)
        })
    }
}

struct CloudNoteView_Previews: PreviewProvider {
    static var previews: some View {
        CloudNoteView(noteId: 9)
    }
}
