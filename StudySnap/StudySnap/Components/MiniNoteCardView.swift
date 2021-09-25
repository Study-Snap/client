//
//  MiniNoteCardView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MiniNoteCardView: View {
    var notes: [ApiNoteResponse]
    var onClick: (Int) -> () = { noteId in print("Clicked \(noteId)") }
    
    var body: some View {
      TabView {
       
        ForEach(notes) { item in
            Button(action: {onClick(item.id!)}, label: {
                VStack {
                    VStack {
                        Image(systemName: "doc.text.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height:50)
                            .padding(.top)
                            .foregroundColor(Color("Secondary"))
                    }
                    VStack {
                        HStack {
                            Text(item.title!).foregroundColor(Color(.gray)).fontWeight(.light)
                        }
                        HStack {
                            VStack{
                                Text("Ben Sykes")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("Secondary"))
                            }.padding(.horizontal, 50)
                            .padding(.bottom)
                            
                        }
                    }
                    
                }
            }).buttonStyle(PlainButtonStyle())
        }
      }
      .tabViewStyle(PageTabViewStyle())
    }
  }


struct MiniNoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniNoteCardView(notes: [])
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
