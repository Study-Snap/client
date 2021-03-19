//
//  MiniNoteCardView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MiniNoteCardView: View {
    
    let coverImages: [CoverImage] = Bundle.main.decode("covers.json")

    var body: some View {
        VStack {
            TabView {
              ForEach(coverImages) { item in
                VStack {
                    Image(item.name)
                      .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .padding(.horizontal)
                    VStack {
                        HStack {
                            Text(item.note)
                                .padding(.leading)
                            Spacer()
                        }
                        HStack {
                            
                            Text(item.user)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                    }
                }
                
              } //: LOOP
            } //: TAB
            .tabViewStyle(PageTabViewStyle())
            
        }
    }
}

struct MiniNoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniNoteCardView()
            .previewLayout(.fixed(width: 400, height: 350))
    }
}
