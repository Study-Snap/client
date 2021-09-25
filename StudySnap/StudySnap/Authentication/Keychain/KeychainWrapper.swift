//
//  KeychainWrapper.swift
//  StudySnap
//
//  Used to simplify access and manipulation of the local keychain for storing sensitive information on the client device.
//  This includes, but is not limited to: Access Tokens, Passwords, API secrets, etc.
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

class KeychainWrapper {
  func storeGenericPasswordFor(
    account: String,
    service: String,
    password: String
  ) throws {
    if password.isEmpty {
      try deleteGenericPasswordFor(account: account, service: service)
      return
    }
    guard let passwordData = password.data(using: .utf8) else {
      print("Error converting value to data.")
      throw KeychainWrapperError(type: .badData)
    }

    // Construct query
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecValueData as String: passwordData
    ]

    // Add the item to keychain
    let status = SecItemAdd(query as CFDictionary, nil)
    switch status {
    case errSecSuccess:
      break
    case errSecDuplicateItem:
      try updateGenericPasswordFor(
        account: account,
        service: service,
        password: password)
    default:
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }

  func getGenericPasswordFor(account: String, service: String) throws -> String {
    // Construct the query
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
        
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
        
      kSecReturnData as String: true
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
      throw KeychainWrapperError(type: .itemNotFound)
    }
    guard status == errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }

    // Get the item from keystore
    guard let existingItem = item as? [String: Any],
      let valueData = existingItem[kSecValueData as String] as? Data,
      let value = String(data: valueData, encoding: .utf8)
      else {
        throw KeychainWrapperError(type: .unableToConvertToString)
    }

    // Return the password
    return value
  }

  func updateGenericPasswordFor(
    account: String,
    service: String,
    password: String
  ) throws {
    guard let passwordData = password.data(using: .utf8) else {
      print("Error converting value to data.")
      return
    }
    
    // Construct query
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service
    ]

    // New updated password data
    let attributes: [String: Any] = [
      kSecValueData as String: passwordData
    ]

    // Update the password
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    guard status != errSecItemNotFound else {
      throw KeychainWrapperError(message: "Matching Item Not Found", type: .itemNotFound)
    }
    guard status == errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }

  func deleteGenericPasswordFor(account: String, service: String) throws {
    // Construct the query
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service
    ]

    // Delete the password from keychain
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }
}

struct KeychainWrapperError: Error {
  var message: String?
  var type: KeychainErrorType

  enum KeychainErrorType {
    case badData
    case servicesError
    case itemNotFound
    case unableToConvertToString
  }

  init(status: OSStatus, type: KeychainErrorType) {
    self.type = type
    if let errorMessage = SecCopyErrorMessageString(status, nil) {
      self.message = String(errorMessage)
    } else {
      self.message = "Status Code: \(status)"
    }
  }

  init(type: KeychainErrorType) {
    self.type = type
  }

  init(message: String, type: KeychainErrorType) {
    self.message = message
    self.type = type
  }
}
