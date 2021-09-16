//
//  InfoPlistParser.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-09-16.
//

import Foundation

struct InfoPlistParser {
    static func getStringValue(forKey key:String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Could not find value for key \(key) in the Info.plist")
        }
        return value
    }
}
