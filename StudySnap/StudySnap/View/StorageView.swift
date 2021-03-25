//
//  StorageView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct StorageView: View {
    @State private var isShowingNotes: Bool = false
    var fruits: [Fruit] = fruitsData
    var body: some View {
      NavigationView {
        List {
          ForEach(fruits.shuffled()) { item in
            NavigationLink(destination: OnBoardingView()) {
              NoteRowView(fruit: item)
                .padding(.vertical, 4)
            }
          }
        }
        .navigationTitle("Storage")
        .navigationBarItems(
          trailing:
            Button(action: {
              isShowingNotes = true
            }) {
              Image(systemName: "plus")
            } //: BUTTON
            .sheet(isPresented: $isShowingNotes) {
              NoteUploadView()
            }
        )

      } //: NAVIGATION
      .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
