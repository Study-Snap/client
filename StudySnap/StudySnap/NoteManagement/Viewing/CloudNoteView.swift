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
    let tempKeywords: [String] = ["Lecture", "Science", "Biology"]
    let tempRatings: [Int] = [5, 2, 12, 5]
    
    // View model
    @StateObject var viewModel: NoteViewViewModel = NoteViewViewModel()
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Color("Primary")
                    VStack {
                        Text("Lecture 5.5: Biology")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(20)
                        Text("Liam Stickney")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .padding(.top, -20)
                            .padding(.bottom, 25)
                        HStack(alignment: .center) {
                            ForEach(0..<3) { i in
                                if !tempKeywords[i].isEmpty {

                                    Text(tempKeywords[i])
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .foregroundColor(Color("Secondary"))
                                        .background(Color(.white))
                                        .cornerRadius(7.0)

                                }
                            }
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 0)
                        VStack {
                            NoteRatingView(avgRating: calculateRating(ratings: tempRatings), starFilledColor: .yellow, starEmptyColor: .white)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, -40)
                    }
                }
                .frame(height: 340, alignment: .center)
                .cornerRadius(15.0)
            }
            .ignoresSafeArea()
            
            VStack {
                Button(action: {print("Test")}, label: {
                    Text("Hello, My Name is Sheharyaar")
                })
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("DESCRIPTION")
                        Text("This is a short description of my biology note.")
                    }.padding()
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("DETAILS")
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed imperdiet placerat dolor in tempor. Fusce eu vehicula mauris, eu vehicula orci. Fusce at risus eu leo tempus imperdiet. Nullam suscipit dolor sapien, rutrum egestas nunc luctus et. Aenean ullamcorper libero ante, sit amet viverra sapien iaculis eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    }.padding()
                    Spacer()
                }
                Spacer()
                
                HStack {
                    Text("About a 5 minute read")
                    Button(action: {print("Cited!")}, label: {
                        Text("Cite This")
                    })
                }

            }
            
            
        }
        .onAppear(perform: {
            self.viewModel.getNoteDetailsForId(id: noteId)
        })
    }
}

struct CloudNoteView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
    
    static var previews: some View {
        CloudNoteView(noteId: 1)
    }
}
