//
//  ClassroomsView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI


struct ClassroomsView: View {
    @Binding var rootIsActive: Bool
    
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
            isEaseInAnimation = .easeOut
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
                                                NavigationLink(destination: NoteSearchView(rootIsActive: self.$rootIsActive, hasLeftClassroom: $isUpdateClassroomView, classID: classroomItem.id!, className: classroomItem.name!)
                                                                .navigationBarTitle("")
                                                                .navigationBarHidden(true)) {
                                                    ClassroomGridItemView(classroom: classroomItem)
                                          
                                                    
                                                        
                                                }.isDetailLink(false)
                                                //: LINK
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
                                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 10)
                                        .strokeStyle()
                                        .padding(.leading, 10)
                                    
                                } //: BUTTON
                                .sheet(isPresented: $isJoiningClassroom) {
                                    JoinClassroomView(rootIsActive: self.$rootIsActive)
                                }
                                
                                Button(action: {
                                    isJoiningClassroom = true
                                }) {
                                    PrimaryButtonView(title: "Create Classroom", action:{
                                        isCreatingClassroom = true
                                    })
                                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 10)
                                        .strokeStyle()
                                        .padding(.trailing, 10)
                                } //: BUTTON
                                .sheet(isPresented: $isCreatingClassroom) {
                                    CreateClassroomView(rootIsActive: self.$rootIsActive)
                                }
                                
                            }.padding(.bottom,10)
                            
                                .navigationBarTitle("Classrooms", displayMode: .inline)
                            
                                .toolbar {
                                    
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        HStack(spacing: 16) {
                                            Button(action: {
                                                print("Update classroom view")
                                                self.viewModel.loading = true
                                                self.viewModel.getClassroomsForUser() {
                                                    if self.viewModel.unauthorized {
                                                        // If we cannot refresh, pop off back to login
                                                        self.rootIsActive = false
                                                    }
                                                }
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
                                } //: TOOLBAR
                            
                        } //: NAVIGATION
                    }
                }
                
            }
            Spacer()
        }
        
        .onAppear(perform: {
            self.viewModel.loading = true
            self.viewModel.getClassroomsForUser() {
                if self.viewModel.unauthorized {
                    // If we cannot refresh, pop off back to login
                    self.rootIsActive = false
                }
            }
        })
        .onChange(of: isUpdateClassroomView) { value in
            self.viewModel.loading = true
            if self.isUpdateClassroomView {
                // Refresh top notes
                self.viewModel.getClassroomsForUser() {
                    if self.viewModel.unauthorized {
                        // If we cannot refresh, pop off back to login
                        self.rootIsActive = false
                    }
                }
                // Reset flag
                self.isUpdateClassroomView = false
            }
        }
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView(rootIsActive: .constant(true))
            .previewDevice("iPhone 11 Pro")
    }
}
