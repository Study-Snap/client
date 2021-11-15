//
//  NoteRatingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI

struct NoteRatingView: View {

    @State var selected = -1
    
    var body: some View {
        
        VStack{
            
            if self.selected != -1{
                
            }
            HStack(spacing: 10, content:{
                ForEach(0..<5){ i in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(self.selected >= i ? .yellow : .gray).onTapGesture {
                            self.selected = i
                        }
                }
            })
        }
        
    }
}

struct NoteRatingView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
   
    static var previews: some View {
        NoteRatingView()
            .previewLayout(.fixed(width: 200, height: 80))
        
    }
}
