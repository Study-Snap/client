//
//  MiniNoteCardView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MiniNoteCardView: View {
    
    
    let coverImages: [CoverImage] = Bundle.main.decode("covers.json")
     
    
    // MARK: - BODY
    
    var body: some View {
      TabView {
        ForEach(coverImages) { item in
          Image(item.name)
            .resizable()
            .scaledToFill()
        } //: LOOP
      } //: TAB
      .tabViewStyle(PageTabViewStyle())
    }
  }


struct MiniNoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniNoteCardView()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
