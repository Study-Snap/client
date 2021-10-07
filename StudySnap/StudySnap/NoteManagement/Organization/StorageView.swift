//
//  StorageView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct StorageView: View {
    @State private var isShowingNotes: Bool = false

    @ObservedObject var globalString = GlobalString()
    @State var isDeleted = false
    @StateObject var viewModel : NoteSearchViewModel = NoteSearchViewModel()
    var body: some View {
      NavigationView {
        List {
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
        .navigationTitle("Storage")
        .navigationBarItems(
          trailing:
            Button(action: {
              isShowingNotes = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color("Secondary"))
            } //: BUTTON
            .sheet(isPresented: $isShowingNotes) {
              NoteUploadView()
            }
        )

      } //: NAVIGATION
      .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func delete(at offSet: IndexSet){
        globalString.notesData.remove(atOffsets: offSet)
        isDeleted = true
        
    }
}


struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
