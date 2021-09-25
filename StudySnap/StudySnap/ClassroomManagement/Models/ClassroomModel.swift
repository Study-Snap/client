//
//  ClassroomModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-25.
//

import SwiftUI


struct Classroom: Codable, Identifiable{
    let id: String
    let name: String
    let ownerId: Int
    let createdAt: String
    let updatedAt: String
    let ClassroomUser: ClassroomUser
    
}
