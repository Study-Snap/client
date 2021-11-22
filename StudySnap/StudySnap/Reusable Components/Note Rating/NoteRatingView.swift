//
//  NoteRatingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI

struct NoteRatingView: View {
    
    @Binding var isDisabled: Bool
    @Binding var selected: Int
    @State var isLoading: Bool = true
    var currentNote: Int
    @StateObject var ratingViewModel : NoteRatingViewModel = NoteRatingViewModel()
    var body: some View {
        
        VStack{
            
            if self.selected != -1{
                
            }
            if self.isLoading{
                ProgressView()
            }else{
                HStack(spacing: 10, content:{
                    if self.isDisabled {
                        ForEach(0..<5){ i in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(self.selected >= i ? .yellow : .gray)
                        }
                    } else {
                        ForEach(0..<5){ i in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(self.selected - 1   >= i ? .yellow : .gray).onTapGesture {
                                    self.selected = i+1
                                }
                        }
                    }
                })
            }

        }
        .onAppear {
            self.ratingViewModel.getAverageRating(currentNoteId: self.currentNote){
                self.selected = self.ratingViewModel.ratingValue - 1
                self.isLoading = false
                
            }
        }
        
    }
}

struct NoteRatingView_Previews: PreviewProvider {
    
   
    static var previews: some View {
        NoteRatingView(isDisabled: .constant(true), selected: .constant(1), currentNote: 1)
            .previewLayout(.fixed(width: 200, height: 80))
        
    }
}
