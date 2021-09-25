//
//  ValidationOverride.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-17.
//

import Foundation
import SwiftUI

struct ValidationError: Codable {
    var statusCode: Int?
    var error: String?
    var message: [String]?
}
