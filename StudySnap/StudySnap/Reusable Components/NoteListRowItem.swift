//
//  NoteListRowItem.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-15.
//

import SwiftUI

func truncateRatingCount(ratingCount: Int) -> String {
    if (ratingCount > 1000000) {
        return "\(ratingCount / 1000000) M"
    } else if (ratingCount > 1000) {
        return "\(ratingCount / 1000) K"
    }
    return "\(ratingCount)"
}

struct NoteListRowItem: View {
    var id: Int
    var title: String
    var author: String
    var shortDescription: String
    var readTime: Int
    var ratings: [RatingModel]
    
    @Binding var rootIsActive: Bool
    @Binding var isRatingDisabled: Bool
    
    @Binding var isNoteUpdated: Bool
    
    var body: some View {
        
        
        HStack {
            ZStack {
                Rectangle()
                    .fill(
                        Color("AccentDark")
                    )
                    .cornerRadius(radius: 12, corners: [.bottomLeft,.topRight])
                
                
                VStack {
                    Text("\(readTime)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text("min")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.8))
                }
            }
            .frame(width: 70, height: 70, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(Color("PrimaryText"))
                Text(author)
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
                
                HStack{
                    NoteRatingView(isDisabled: $isRatingDisabled, rootIsActive: self.$rootIsActive, isNoteUpdated: self.$isNoteUpdated, currentNote: id)
                        .accentColor(.yellow)
                    Text("(\(truncateRatingCount(ratingCount: self.ratings.count)))")
                        .font(.body)
                        .foregroundColor(Color("Secondary"))
                        .padding(.leading, 5)
                }
            }.padding(.leading, 6)
            
        }
    }
}

/*struct NoteListRowItem_Previews: PreviewProvider {
    static var previews: some View {
        /*Group {
            NoteListRowItem(id: 1, title: "Science Lecture 7", author: "Liam Stickney", shortDescription: "This is a note all about science and chemestry and stuff related to sheharyaars", readTime: 5, rating: [0,2,3,20,5], selectedRating: 3, isRatingDisabled: .constant(true))
            
            NoteListRowItem(id: 1, title: "Science Lecture 7", author: "Liam Stickney", shortDescription: "This is a note all about science and chemestry and stuff related to sheharyaars", readTime: 5, rating: [0,2,3,20,5], selectedRating: 5, isRatingDisabled: .constant(true))
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }*/
    }
}
*/
