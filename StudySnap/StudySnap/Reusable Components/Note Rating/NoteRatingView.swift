//
//  NoteRatingView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI

struct NoteRatingView: View {
    
    @Binding var isDisabled: Bool
    @Binding var rootIsActive: Bool
    @State var selected: Int = 0
    @State var isLoading: Bool = true
    @State var isNoteRatingUpdate: Bool = false
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
                                .foregroundColor(self.selected >= i ? .yellow : .gray).onTapGesture {
                                    self.selected = i
                                    self.isNoteRatingUpdate = true
                                }
                        }
                    }
                    
                })
            }

        }
        .onAppear {
            self.ratingViewModel.getAverageRating(currentNoteId: self.currentNote) {
                self.selected = self.ratingViewModel.ratingValue - 1
                self.isLoading = false
            }
        }
        .onChange(of: self.isNoteRatingUpdate) { value in
            self.ratingViewModel.putRating(ratingValue: self.selected + 1, currentNoteId: currentNote) {
                if self.ratingViewModel.unauthorized {
                    // Refresh failed, return to login
                    self.rootIsActive = false
                }
            }
        }
        
    }
}

struct NoteRatingView_Previews: PreviewProvider {
    
   
    static var previews: some View {
        NoteRatingView(isDisabled: .constant(true), rootIsActive: .constant(false), selected: 1, currentNote: 1)
            .previewLayout(.fixed(width: 200, height: 80))
        
    }
}
