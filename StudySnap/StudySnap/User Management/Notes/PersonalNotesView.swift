//
//  StorageView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct PersonalNotesView: View {
    @State private var isShowingNotes: Bool = false
    @Binding var rootIsActive: Bool
    @State var isNoteUpdated: Bool = false
    @State var isDeleted = false
    @StateObject var viewModel : PersonalNotesViewModel = PersonalNotesViewModel()
    @StateObject var ratingViewModel : NoteRatingViewModel = NoteRatingViewModel()
    @State var targetNoteId: Int? = 1
    @State var showNoteDetails = false
    @State var refresh: Bool = false
    @State var isRatingDisabled: Bool = true
    @State var noteRating: Int = 1
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                
                if viewModel.results.count > 0 {
                    VStack {
                        
                        VStack {
                            NavigationLink(
                                destination: DetailedNoteView(rootIsActive: self.$rootIsActive, isNoteUpdated: self.$isNoteUpdated, noteId: self.targetNoteId!)   .navigationBarBackButtonHidden(true) ,
                                isActive: $showNoteDetails,
                                label: {
                                    EmptyView()
                                    
                                }).isDetailLink(false)
                            
                        }
                        
                        List{
                            
                            ForEach(viewModel.results) { item in
                                
                              
                                NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, ratings: item.ratings!, rootIsActive: self.$rootIsActive, isRatingDisabled: $isRatingDisabled, isNoteUpdated: self.$isNoteUpdated)
                                    .onAppear {
                                        self.ratingViewModel.getAverageRating(currentNoteId: item.id!){
                                            self.noteRating = self.ratingViewModel.ratingValue - 1
                                        }
                                    }
                                    .swipeActions() {
                                        Button(action: {
                                            self.viewModel.deleteUserNote(userNoteId: item.id!) {
                                                self.isDeleted = true
                                                self.refresh = true
                                            }
                                            
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                    }
                                    .onTapGesture {
                                        self.targetNoteId = item.id!
                                        self.showNoteDetails.toggle()
                                    }.padding(.vertical, 10)
                                
                                
                            }
                            
                            
                            
                            
                            
                        }.listStyle(.plain)
                        
                    }.navigationBarTitle("Personal Notes",displayMode: .inline)
                        .toolbar {
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack(spacing: 16) {
                                    Button(action: {
                                        self.refresh = true
                       
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(Color("Secondary"))
                                        
                                    }
                                } //: HSTACK
                            } //: BUTTONS
                        } //: TOOLBAR
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("AccentDark"))
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding()
                        Text("No notes could be found\nTry Uploading some")
                            .font(.headline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("AccentDark"))
                            .padding(.horizontal)
                        Spacer()
                        Spacer()
                    }
                    .cornerRadius(12)
                }
                
            } //: NAVIGATION
            
        }.onAppear(perform: {
            self.viewModel.getPersonalUserNotes(){
                if self.viewModel.unauthorized {
                    // Refresh failed, return to login
                    self.rootIsActive = false
                }
            }
           
        })
            .onChange(of: refresh || isNoteUpdated) { value in
                if self.refresh || self.isNoteUpdated {
                    // Refresh top notes
                    self.viewModel.getPersonalUserNotes() {
                        if self.viewModel.unauthorized {
                            // Refresh failed, return to login
                            self.rootIsActive = false
                        }
                    }
                    
                    // Reset flag
                    self.isNoteUpdated = false
                    self.refresh = false
                }
            }
    }
    
}


struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalNotesView(rootIsActive: .constant(true))
    }
}
