//
//  LocalNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct LocalNoteView: View {
    let note: Note
    
    @State var showToggle = false
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
                
                Toggle(isOn: $showToggle){
                    
                    Text("Public")
                    
                }

            }.padding(.horizontal,30)
        }
 
    }
}

struct LocalNoteView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
    
    static var previews: some View {
        LocalNoteView(note: notes[0])
            .previewDevice("iPhone 11")    }
}
