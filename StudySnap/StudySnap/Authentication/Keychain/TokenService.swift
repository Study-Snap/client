//
//  TokenService.swift
//  StudySnap
//
//  Designed to make it easy to add/remove/update/delete access and refresh tokens from keychain
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

struct Token {
    var type: TokenType
    var data: String
    
    enum TokenType {
        case accessToken
        case refreshToken
    }
}

class TokenService {
    let KEYCHAIN_ACCOUNT: String = "StudySnap"
    
    func addToken(token: Token) -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.storeGenericPasswordFor(
                    account: KEYCHAIN_ACCOUNT,
                    service: token.type == Token.TokenType.accessToken ? "accessToken" : "refreshToken",
                    password: token.data
                )
        } catch let error as KeychainWrapperError {
            print("Exception when setting token in keychain: \(error.message ?? "no message")")
        } catch {
            print("An unknown error occurred setting the token")
        }
    }
    
    func getToken(key: Token.TokenType) -> String {
        let kcw = KeychainWrapper()
        if let password = try? kcw.getGenericPasswordFor(account: KEYCHAIN_ACCOUNT, service: key == Token.TokenType.accessToken ? "accessToken" : "refreshToken") {
            return password
        }
        
        // Empty string means no token was found
        return ""
    }
    
    func removeToken(key: Token.TokenType) -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.deleteGenericPasswordFor(
                account: KEYCHAIN_ACCOUNT,
                service: key == Token.TokenType.accessToken ? "accessToken" : "refreshToken"
            )
        } catch let error as KeychainWrapperError {
            print("Exception when attempting to remove a token in keychain: \(error.message ?? "no message")")
        } catch {
            print("An unknown error occurred removing a token from keychain")
        }
    }
    
    func updateToken(key: Token.TokenType, data: String) -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.updateGenericPasswordFor(
                account: KEYCHAIN_ACCOUNT,
                service: key == Token.TokenType.accessToken ? "accessToken" : "refreshToken",
                password: data
            )
        } catch let error as KeychainWrapperError {
            print("Exception when attempting to update a token in keychain: \(error.message ?? "no message")")
        } catch {
            print("An unknown error occurred updating a token from keychain")
        }
    }
    
}
