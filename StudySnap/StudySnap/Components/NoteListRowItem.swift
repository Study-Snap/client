//
//  NoteListRowItem.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-15.
//

import SwiftUI

struct NoteListRowItem: View {
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
                                    .foregroundColor(Color("TextFieldPrimary"))
                                
                                Text("min")
                                    .font(.caption)
                                    .foregroundColor(Color("TextFieldPrimary"))
                            }
                        }
                        .frame(width: 70, height: 70, alignment: .center)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(Color("Secondary"))
                            Text(author)
                                .font(.caption)
                                .padding(.bottom, 5)
                            
                            
                            HStack(alignment: .center) {
                                Text(shortDescription)
                                    .font(.footnote)
                            }
                            .padding(.bottom, 5)
                            
                            HStack {
                                NoteRatingView(avgRating: calculateRating(ratings: rating))
                            }
                            
                        }
                        .padding(.horizontal, 5)
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
        NoteListRowItem(title: "Science Lecture 5", author: "Liam Stickney", shortDescription: "This is a note about science and biology and includes physics too", readTime: 5, rating: [0,2,3,20,5])
    }
}

func calculateRating(ratings: [Int]) -> Int {
    return ratings.firstIndex(of: ratings.max()!)! + 1
}
