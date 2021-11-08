//
//  ClassroomGridItemView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI

struct ClassroomGridItemView: View {
    // MARK: - PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    var classroom: ApiClassroomResponse
    
    // MARK: - BODY

    var body: some View {
        
        VStack(alignment:.leading){
            Image("classroomImage")
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
            Text(classroom.name ?? "ERROR")
                .font(.subheadline)
                .bold()
                .padding(.horizontal,5)
                .padding(.bottom, 10)
                .lineLimit(1)

        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
        .strokeStyle()

    }
}

struct ClassroomGridItemView_Previews: PreviewProvider {

    //Preview testing data
    
    //Testing code
    static let classrooms: ApiClassroomResponse = ApiClassroomResponse(id: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", name: "Bio 202", ownerId: 1, statusCode: 200, error: "Testing", message: "Testing message")
    //static let classrooms: Classroom = Classroom(id: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", name: "History 101", ownerId: 1, createdAt: "2021-09-22T00:04:50.368Z", updatedAt: "2021-09-25T22:52:57.388Z", ClassroomUser: ClassroomUser(classId: "448f7db0-e3ac-4875-9235-5e08ffa4ed82", userId: 1, createdAt: "2021-09-22T00:04:50.461Z", updatedAt: "2021-09-22T00:04:50.461Z"))
    static var previews: some View {
            EmptyView()
    }}
