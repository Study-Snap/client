//
//  NoteRowView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct NoteRowView: View {
    
    var fruit: Fruit

    var body: some View {
      HStack {
        VStack {
            Image(systemName: "doc.text.fill")        .resizable()
                .scaledToFill()
                .frame(width: 33, height: 30)

    
        }
        VStack(alignment: .leading, spacing: 5) {
          Text(fruit.title)
            .font(.title2)
            .fontWeight(.bold)
          Text(fruit.headline)
            .font(.caption)
            .foregroundColor(Color.secondary)
        }
      } //: HSTACK
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
     NoteRowView(fruit: fruitsData[0])
          .previewLayout(.sizeThatFits)
          .padding()
    }
}
