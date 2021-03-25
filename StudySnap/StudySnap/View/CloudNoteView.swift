//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct CloudNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let note: Note
    
    var body: some View {
        //Labore sunt veniam amet es...
        
        ScrollView {
            VStack(alignment: .leading) {
                        //Science Class Note
                        Text(note.title)
                            .font(.title)
                            .padding(.top)
                        
                        Text(note.author)
                            .font(.headline)
                            .padding(.vertical)
                        
                        Text(note.description)
                            .font(.body)
                        
                        Text("Topic(s): " + note.subject.joined(separator: ", "))
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("Keywords: " + note.keywords.joined(separator: ", "))
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("Length: " + String(note.length) + " words")
                            .fontWeight(.bold)
                            .padding(.top)
             
                NoteRatingView(note: note)
                    .padding(.vertical)
                   
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("Primary"))
                            .frame(width: 370, height: 60)
                        //Save Note
                        Text("Save Note").font(.custom("Inter Semi Bold", size: 16)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)

                    }
                }
              
            }.padding(.horizontal,30)
        }
                
            
        
    }
}

struct CloudNoteView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
    
    static var previews: some View {
        CloudNoteView(note: notes[4])
            .previewDevice("iPhone 11")    }
}
