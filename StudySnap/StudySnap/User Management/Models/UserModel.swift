//
//  UserModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-10-02.
//

import SwiftUI

struct UserModel: Codable, Identifiable{
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    
}
