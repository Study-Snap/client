//
//  AuthorModel.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-11-19.
//

import Foundation

struct Citation: Codable {
    var authorFirstName: String
    var authorLastName: String
    var publishYear: Int
    var publishTitle: String
}
