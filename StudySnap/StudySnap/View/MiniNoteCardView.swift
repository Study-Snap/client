//
//  MiniNoteCardView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct MiniNoteCardView: View {
    
    
    //let notes: [Note] = Bundle.main.decode("notes_data.json")

    @ObservedObject var globalString = GlobalString()
    // MARK: - BODY
    
    var body: some View {
      TabView {
       
        ForEach(globalString.notesData) { item in

                VStack {
                    NavigationLink(destination:{
                        VStack{
                            if item.isOnline{
                                CloudNoteView(note: item)
                            }else{
                                LocalNoteView(note: item)
                            }
                        }
                    }()) {Image(systemName: "doc.text.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height:100)
                        .padding(.top)
                    }
                    VStack {
                        HStack {
                            VStack {
                                Text(String(item.title))
                                
                            }.padding(.horizontal, 50)
                            
                        }
                        HStack {
                            VStack{
                                Text(String(item.author))
                                    .fontWeight(.bold)
                            }.padding(.horizontal, 50)
                            .padding(.bottom)
                            
                        }
                    }
                    
                }
            

            
        }//: LOOP
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
