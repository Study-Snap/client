//
//  CloudNoteView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct CloudNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let noteId: Int
    
    // View model
    @StateObject var viewModel: NoteViewViewModel = NoteViewViewModel()
    
    var body: some View {
        ScrollView {
            if self.viewModel.loading {
                ProgressView("Loading Note Details...")
            } else {
                Text("\(self.viewModel.title!)")
            }
        }.onAppear(perform: {
            self.viewModel.getNoteDetailsForId(id: noteId)
        })
    }
}

struct CloudNoteView_Previews: PreviewProvider {
    static let notes: [Note] = Bundle.main.decode("notes_data.json")
    
    static var previews: some View {
        CloudNoteView(noteId: 1)
    }
}
