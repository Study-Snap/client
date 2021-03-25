//
//  NoteDataView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-25.
//

import SwiftUI


class GlobalString: ObservableObject {
  @Published var notesData: [Note] = Bundle.main.decode("notes_data.json")
}
var buttonPressed = false
struct NoteDataView: View{
    var body: some View{
        Text("Hello")
    }
}

struct NoteDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDataView()
    }
}
