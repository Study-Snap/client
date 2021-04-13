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
    
    func addToken(token: Token) throws -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.storeGenericPasswordFor(
                    account: KEYCHAIN_ACCOUNT,
                    service: token.type == Token.TokenType.accessToken ? "accessToken" : "refreshToken",
                    password: token.data
                )
        } catch let error as KeychainWrapperError {
            print("Exception when setting token in keychain: \(error.message ?? "no message")")
            throw TokenServiceError(message: error.message ?? "no message", type: TokenServiceError.TokenServiceErrorType.addFailure)
        } catch {
            print("An unknown error occurred setting the token")
            throw TokenServiceError(type: TokenServiceError.TokenServiceErrorType.addFailure)
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
    
    func removeToken(key: Token.TokenType) throws -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.deleteGenericPasswordFor(
                account: KEYCHAIN_ACCOUNT,
                service: key == Token.TokenType.accessToken ? "accessToken" : "refreshToken"
            )
        } catch let error as KeychainWrapperError {
            print("Exception when attempting to remove a token in keychain: \(error.message ?? "no message")")
            throw TokenServiceError(message: error.message ?? "no message", type: TokenServiceError.TokenServiceErrorType.deleteFail)
        } catch {
            print("An unknown error occurred removing a token from keychain")
            throw TokenServiceError(type: TokenServiceError.TokenServiceErrorType.deleteFail)
        }
    }
    
    func updateToken(key: Token.TokenType, data: String) throws -> Void {
        let kcw = KeychainWrapper()
        do {
            try kcw.updateGenericPasswordFor(
                account: KEYCHAIN_ACCOUNT,
                service: key == Token.TokenType.accessToken ? "accessToken" : "refreshToken",
                password: data
            )
        } catch let error as KeychainWrapperError {
            print("Exception when attempting to update a token in keychain: \(error.message ?? "no message")")
            throw TokenServiceError(message: error.message ?? "no message", type: TokenServiceError.TokenServiceErrorType.badUpdate)
        } catch {
            print("An unknown error occurred updating a token from keychain")
            throw TokenServiceError(type: TokenServiceError.TokenServiceErrorType.badUpdate)
        }
    }
    
}

struct TokenServiceError: Error {
  var message: String?
  var type: TokenServiceErrorType

  enum TokenServiceErrorType {
    case deleteFail
    case badRequest
    case badUpdate
    case addFailure
  }
    
  init(type: TokenServiceErrorType) {
    self.type = type
  }

  init(message: String, type: TokenServiceErrorType) {
    self.message = message
    self.type = type
  }
}
