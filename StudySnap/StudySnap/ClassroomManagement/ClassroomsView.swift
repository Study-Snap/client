//
//  ClassroomsView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct ClassroomsView: View {

    var classrooms: [Classroom] = Bundle.main.decode("classrooms_data.json")
    
    @State private var isGridViewActive: Bool = false
    
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    @State private var gridColumn: Int = 1
    @State private var toolbarIcon: String = "square.grid.2x2"
    @State var targetNoteId: Int? = 1
    //: MARK - FUNCTIONS
    
    func gridSwitch() {
      gridLayout = Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1)
      gridColumn = gridLayout.count
      print("Grid Number: \(gridColumn)")
      
      // TOOLBAR IMAGE
      switch gridColumn {
      case 1:
        toolbarIcon = "square.grid.2x2"
      case 2:
        toolbarIcon = "square.grid.3x2"
      case 3:
        toolbarIcon = "rectangle.grid.1x2"
      default:
        toolbarIcon = "square.grid.2x2"
      }
    }

    var body: some View {
        
        // MARK: - BODY
        VStack{
            NavigationView {
              Group {
                  ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                      ForEach(classrooms) { classroomItem in
                        NavigationLink(destination: RecommendationView()) {
                          ClassroomGridItemView(classroom: classroomItem)
                        } //: LINK
                      } //: LOOP
                    } //: GRID
                    .padding(10)
                    .animation(.easeIn)
                  } //: SCROLL
              } //: GROUP
              .navigationBarTitle("Classrooms", displayMode: .large)
              .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  HStack(spacing: 16) {
                    
                    // GRID
                    Button(action: {
                      print("Grid view is activated")
                      isGridViewActive = true
                      gridSwitch()
                    }) {
                      Image(systemName: toolbarIcon)
                        .font(.title2)
                        .foregroundColor(isGridViewActive ? .accentColor : .primary)
                    }
                  } //: HSTACK
                } //: BUTTONS
              } //: TOOLBAR
            } //: NAVIGATION
            HStack{
                PrimaryButtonView(title: "Join Classroom", action: {})
                    .padding(.leading, 10)
                   
                PrimaryButtonView(title: "Create Classroom", action: {})
                    .padding(.trailing, 10)
                
            
            }.padding(.bottom)
            
        }
      }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
    }
}
