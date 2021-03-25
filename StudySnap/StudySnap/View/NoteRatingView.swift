//
//  NoteRatingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI

struct NoteRatingView: View {
    var note: Note
    
    var body: some View {
      HStack(alignment: .center, spacing: 5) {
        ForEach(1...(note.rating), id: \.self) { _ in
          Image(systemName: "star.fill")
            
            .font(.body)
            .foregroundColor(Color.yellow)
            .scaledToFit()
        }
      }
    }
}

struct NoteRatingView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
   
    static var previews: some View {
        NoteRatingView(note: notes[6] )
            .previewLayout(.fixed(width: 200, height: 80))
        
    }
}
