//
//  NoteRatingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI

struct NoteRatingView: View {
    var avgRating: Int
    var size: Int = 5
    
    // Styles
    var starFilledColor: Color = Color("Primary")
    var starEmptyColor: Color = Color("AccentDark")
    
    var body: some View {
      HStack(alignment: .center, spacing: 5) {
        
        ForEach(1 ..< size+1) { i in
            if i <= avgRating {
                Image(systemName: "star.fill")
                    .font(.body)
                    .foregroundColor(starFilledColor)
                    .scaledToFit()
            } else {
                Image(systemName: "star.fill")
                    .font(.body)
                    .foregroundColor(starEmptyColor)
                    .scaledToFit()
            }
        }
      }
    }
}

struct NoteRatingView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
   
    static var previews: some View {
        NoteRatingView(avgRating: 3)
            .previewLayout(.fixed(width: 200, height: 80))
        
    }
}
