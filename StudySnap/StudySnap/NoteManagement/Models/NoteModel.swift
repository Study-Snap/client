//
//  NoteModel.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-24.
//

import SwiftUI

struct Note: Identifiable, Codable {
    var id : Int
    var title: String
    var author: String
    var keywords: [String]
    var subject: [String]
    var length: Int
    var image: String
    var isOnline: Bool
    var rating: Int
    var description: String
}
