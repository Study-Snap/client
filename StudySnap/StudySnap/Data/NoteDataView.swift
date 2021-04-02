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
