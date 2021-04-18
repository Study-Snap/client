//
//  UtilFunctions.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-17.
//

import SwiftUI

func calculateRating(ratings: [Int]) -> Int {
    return ratings.firstIndex(of: ratings.max()!)! + 1
}
