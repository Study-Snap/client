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
    @ObservedObject var globalString = GlobalString()
    @State var isDeleted = false
    @StateObject var viewModel : PersonalNotesViewModel = PersonalNotesViewModel()
    @State var targetNoteId: Int? = 1
    @State var showNoteDetails = false
    var body: some View {
        VStack {
            NavigationView {
              
            /*List {
                ForEach(globalString.notesData) { item in
                    NavigationLink(destination:{
                        VStack{
                            LocalNoteView(note: item)
                        }
                    }()) {
                        NoteRowView(note: item)
                            .padding(.vertical, 4)
                        
                    }
                }
                .onDelete(perform: delete)
            }
             */
                VStack {
                   
                    VStack {
                        NavigationLink(
                            destination: DetailedNoteView(rootIsActive: self.$rootIsActive, noteId: self.targetNoteId!)   .navigationBarBackButtonHidden(true) ,
                            isActive: $showNoteDetails,
                            label: {
                                EmptyView()
                                
                            }).isDetailLink(false)
                        
                    }
                          
                    ScrollView{
                        ForEach(viewModel.results) { item in
                                      
                                      NoteListRowItem(id: item.id!, title: item.title!, author: "\(item.user!.firstName) \(item.user!.lastName)", shortDescription: item.shortDescription!, readTime: item.timeLength!, rating: [0,0,0,0,0])
                                          .onTapGesture {
                                              self.targetNoteId = item.id!
                                              self.showNoteDetails.toggle()
                                          }
                                      
                                  }
                              
                          
                      
                        
                    }
                /*.navigationBarItems(
                  trailing:
                    Button(action: {
                      isShowingNotes = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(Color("Secondary"))
                    } //: BUTTON
                    .sheet(isPresented: $isShowingNotes) {
                      //NoteUploadView() // MARK: Implement when working on perosnal storage
                    }
            )*/
                }.navigationBarTitle("Storage", displayMode: .inline)

          } //: NAVIGATION
           
        }.onAppear(perform: {
            self.viewModel.getPersonalUserNotes(){
                if self.viewModel.unauthorized {
                    // Refresh failed, return to login
                    self.rootIsActive = false
                }
            }
        })
    }
    
    // DEPRICATED CODE
    private func delete(at offSet: IndexSet){
        globalString.notesData.remove(atOffsets: offSet)
        isDeleted = true
        
    }
}


struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalNotesView(rootIsActive: .constant(true))
    }
}
