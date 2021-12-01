//
//  CreateClassroomView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct CreateClassroomView: View {
    // Global
    @Environment(\.presentationMode) var presentationMode
    @Binding var rootIsActive: Bool
    
    // State
    @StateObject var viewModel: CreateClassroomViewModel = CreateClassroomViewModel()
    @State private var isShowingPhotoPicker = false
    @State private var classThumbnailImage = UIImage(named: "classthumbnail")!
    @State private var incompleteEntry = false
    @State private var uploading: Bool = false
    
    @Binding var isClassroomsUpdated: Bool
    
    var body: some View {
        NavigationView {
            if (uploading && !self.viewModel.error) {
                ProgressView("Creating the classroom!")
                    .foregroundColor(Color("Secondary"))
            } else {
                VStack {
                    InputField(fieldHeight: 15, textStyle: .emailAddress, autoCap: false, placeholder: "Enter a classroom name", value: $viewModel.name).padding(.top, 20).padding(.bottom, 10).padding(.horizontal, 17.5)
                    VStack {
                        VStack {
                            Image(uiImage: classThumbnailImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipShape(Rectangle())
                                .cornerRadius(12)
                                .padding(.horizontal)
                            .padding(.top)
                            
                            Text("Pick Image from Photo album")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.bottom)
                        }
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                    }
                    .sheet(isPresented: $isShowingPhotoPicker, content: {
                        PhotoPicker(classThumbnailImage: $classThumbnailImage)
                    })
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                    .strokeStyle()


                    Spacer()
                    PrimaryButtonView(title:"Create", action: {
                        self.uploading = true
                        if !viewModel.name.isEmpty{
                            self.viewModel.createClassroom(classCreateData: CreateClassroomData(name: viewModel.name, thumbnailData: classThumbnailImage.pngData())) {
                                self.uploading = false
                                if self.viewModel.unauthorized {
                                    // Refresh failed, return to login
                                    self.rootIsActive = false
                                } else {
                                    self.isClassroomsUpdated = true // Force refresh on classroom dashboard when classroom is created
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }else{
                            self.incompleteEntry = true
                        }
                        
                    })
                    .padding()
                    .alert("Error: Missing information", isPresented: $incompleteEntry) {
                        Button("Ok", role: .cancel){
                            self.incompleteEntry = false
                        }
                    } message:{
                        Text("Please enter a class name")
                    }
                }.navigationBarTitle("Create Classroom", displayMode: .inline)
            }
        }
    }
}

struct CreateClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateClassroomView(rootIsActive: .constant(true), isClassroomsUpdated: .constant(false))
    }
}
