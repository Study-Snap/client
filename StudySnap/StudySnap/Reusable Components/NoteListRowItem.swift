//
//  NoteListRowItem.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-15.
//

import SwiftUI

struct NoteListRowItem: View {
    var id: Int
    var title: String
    var author: String
    var shortDescription: String
    var readTime: Int
    var rating: [Int]

    
    var body: some View {
     
            ZStack(alignment: .leading) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(
                                        Color("AccentDark")
                                    )
                                    .cornerRadius(7.0)
                                
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
                                    .padding(.bottom, 5)
                                
                                
                                
                                    Text(shortDescription)
                                        .font(.footnote)
                                        .multilineTextAlignment(TextAlignment.leading)
                                        .foregroundColor(Color("Secondary"))
                                        .padding(.bottom, 5)
                                
                               
                                    //NoteRatingView(avgRating: calculateRating(ratings: rating))
                                    NoteRatingView()
                                    .accentColor(.yellow)
                                    
                                
                                
                            }
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                        .padding(15)
                        .padding(.horizontal, 17)
                        .background(Color("Accent"))
                        .cornerRadius(7)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
     
    }
}

struct NoteListRowItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoteListRowItem(id: 1, title: "Science Lecture 7", author: "Liam Stickney", shortDescription: "This is a note all about science and chemestry and stuff related to sheharyaars", readTime: 5, rating: [0,2,3,20,5])
            
            NoteListRowItem(id: 1, title: "Science Lecture 7", author: "Liam Stickney", shortDescription: "This is a note all about science and chemestry and stuff related to sheharyaars", readTime: 5, rating: [0,2,3,20,5])
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
