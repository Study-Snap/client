//
//  ClassroomGridItemView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct ClassroomGridItemView: View {
    // MARK: - PROPERTIES
    
    var classroom: ApiClassroomsResponse
    
    // MARK: - BODY

    var body: some View {
        VStack(alignment:.center){
            Image("classroomImage")
              .resizable()
              .scaledToFit()
              .cornerRadius(12)
            
            Text(classroom.name ?? "ERROR 404")
                .font(.title3)
                .bold()
        }

    }
}

struct ClassroomGridItemView_Previews: PreviewProvider {

    //Preview testing data
    
    //Testing code
    static let classrooms: ApiClassroomsResponse = ApiClassroomsResponse(id: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", name: "Bio 202", ownerId: 1, statusCode: 200, error: "Testing", message: "Testing message")
    //static let classrooms: Classroom = Classroom(id: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", name: "History 101", ownerId: 1, createdAt: "2021-09-22T00:04:50.368Z", updatedAt: "2021-09-25T22:52:57.388Z", ClassroomUser: ClassroomUser(classId: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", userId: 1, createdAt: "2021-09-22T00:04:50.461Z", updatedAt: "2021-09-22T00:04:50.461Z"))
    static var previews: some View {
            EmptyView()
    }}
