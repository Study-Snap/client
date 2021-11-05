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

func refreshAccessWithHandling(completion: @escaping (Bool) -> ()) {
    AuthApi().refreshTokens() { tokens in
        if tokens.message != nil && tokens.message != "success" {
            // Error refreshing tokens (known error)
            try! TokenService().removeToken(key: .accessToken)
            try! TokenService().removeToken(key: .refreshToken)
            completion(false)
        } else {
            do {
                // Refresh authentication if possible, else, send user back to login
                try TokenService().removeToken(key: .accessToken)
                try TokenService().removeToken(key: .refreshToken)
                try TokenService().addToken(token: Token(type: .accessToken, data: tokens.accessToken!))
                try TokenService().addToken(token: Token(type: .refreshToken, data: tokens.refreshToken!))
                completion(true)
            } catch {
                // Unknown error refreshing tokens
                try! TokenService().removeToken(key: .accessToken)
                try! TokenService().removeToken(key: .refreshToken)
                completion(false)
            }
        }
    }
}
