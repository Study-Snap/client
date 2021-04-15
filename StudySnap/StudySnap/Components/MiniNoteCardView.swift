//
//  MiniNoteCardView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MiniNoteCardView: View {
    @ObservedObject var globalString = GlobalString()
    var body: some View {
      TabView {
       
        ForEach(globalString.notesData) { item in

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
                            Text(item.title).foregroundColor(Color(.gray)).fontWeight(.light)
                        }
                        HStack {
                            VStack{
                                Text(String(item.author))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("Secondary"))
                            }.padding(.horizontal, 50)
                            .padding(.bottom)
                            
                        }
                    }
                    
                }
            

            
        }
      }
      .tabViewStyle(PageTabViewStyle())
    }
  }


struct MiniNoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniNoteCardView()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
