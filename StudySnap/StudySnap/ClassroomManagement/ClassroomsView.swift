//
//  ClassroomsView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI


struct ClassroomsView: View {
    
    //var classrooms: [Classroom] = Bundle.main.decode("classrooms_data.json")
    
    
    @State private var isGridViewActive: Bool = false
    @State private var isUpdateClassroomView: Bool = false
    
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    @State private var gridColumn: Int = 1
    @State private var toolbarIcon: String = "square.grid.2x2"
    @State var targetNoteId: Int? = 1
    @State private var isEaseInAnimation: Animation?
    @State private var isJoiningClassroom: Bool = false
    @State private var isCreatingClassroom: Bool = false
    //: MARK - FUNCTIONS
    
    // View model
    @StateObject var viewModel: ClassroomViewViewModel = ClassroomViewViewModel()
    
    func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: gridLayout.count % 2 + 1)
        gridColumn = gridLayout.count
        print("Grid Number: \(gridColumn)")
        
        // TOOLBAR IMAGE
        switch gridColumn {
        case 1:
            toolbarIcon = "square.grid.2x2"
            isEaseInAnimation = .none
        case 2:
            toolbarIcon = "rectangle.grid.1x2"
            isEaseInAnimation = .easeIn
        default:
            toolbarIcon = "square.grid.2x2"
        }
    }
    
    var body: some View {
        
        // MARK: - BODY
        VStack {
            NavigationView {
                VStack {
                    
                    if viewModel.loading {
                
                        ProgressView("Loading classrooms")
                            .foregroundColor(Color("Secondary"))
          
                    } else {
                        VStack{
                            var classrooms = viewModel.results
                            
                           
                                Group {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        
                                        if !classrooms.isEmpty {
                                            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                                                ForEach(classrooms) { classroomItem in
                                                    NavigationLink(destination: NoteSearchView(classID: classroomItem.id!, className: classroomItem.name!)) {
                                                        ClassroomGridItemView(classroom: classroomItem)
                                                    } //: LINK
                                                } //: LOOP
                                            } //: GRID
                                            .animation(isEaseInAnimation)
                                            .padding(10)
                                          
                                        } else {
                                            
                                            VStack(alignment: .center){
                                                Spacer()
                                                Image(systemName: "questionmark.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(Color("AccentDark"))
                                                    .frame(width: 100, height: 100, alignment: .center)
                                                    .padding()
                                                Text("You are not registered in any classroom")
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color(.systemGray))
                                                Spacer()
                                            }
                                        }
                                    } //: SCROLL
                                   
                                } //: GROUP
                                
                                HStack{
                                    Button(action: {
                                        isJoiningClassroom = true
                                    }) {
                                        PrimaryButtonView(title: "Join Classroom", action:{
                                            isJoiningClassroom = true
                                        })
                                            .padding(.leading, 10)
                                        
                                    } //: BUTTON
                                    .sheet(isPresented: $isJoiningClassroom) {
                                        JoinClassroomView()
                                    }
                                    
                                    Button(action: {
                                        isJoiningClassroom = true
                                    }) {
                                        PrimaryButtonView(title: "Create Classroom", action:{
                                            isCreatingClassroom = true
                                        })
                                            .padding(.trailing, 10)
                                    } //: BUTTON
                                    .sheet(isPresented: $isCreatingClassroom) {
                                        CreateClassroomView()
                                    }
                                    
                                }.padding(.bottom,10)
                                
                                //Debugging code only
                                //var check = print("This is the error message \(self.viewModel.errorMessage)")
                                //var check2 = print("This is the correct message \(self.viewModel.results)")
                                
                                
                            
                            .padding(.top, 1)
                            .navigationBarTitle("Classrooms", displayMode: .inline)
                            
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            print("Update classroom view")
                                            isUpdateClassroomView = true
                                            self.viewModel.loading = true
                                            self.viewModel.getClassroomsForUser()
                                            //MARK: Include code for updating the classroom view
                                        }) {
                                            Image(systemName: "arrow.clockwise")
                                                .foregroundColor(Color("Secondary"))
                                            
                                        }
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
                            }.background(Color(.systemGray6)) //: TOOLBAR
                            
                        }//: NAVIGATION
                    }
                }
            }
        }.onAppear(perform: {
            self.viewModel.getClassroomsForUser()
            
        })
           
        
        
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
            .previewDevice("iPhone 11 Pro")
    }
}
