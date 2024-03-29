//
//  Authentication.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-03.
//

import SwiftUI

struct User : Codable {
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, message
        
        case id = "id"
    }
    
    var id : Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    
    // Useful if there is an error with decodable message format
    var message: String?
}

struct UserAuth: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, message
    }
    
    var accessToken: String?
    var refreshToken: String?
    
    // Useful if there is an error
    var message: String?
}

class AuthApi {
    let authBaseUrl: String = "\(InfoPlistParser.getStringValue(forKey: Constants.PROTOCOL_KEY))://\(InfoPlistParser.getStringValue(forKey: Constants.AUTH_KEY))"
    
    func register(student: Student, completion: @escaping (User) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(authBaseUrl)/register")
        
        let parameters : [String: String] = [
            "firstName": student.firstName,
            "lastName": student.lastName,
            "email": student.email,
            "password": student.password
        ]
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    completion(user)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(User(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(User(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func changePassword(password: String, newPassword: String, completion: @escaping (User) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(authBaseUrl)/password")
        
        let parameters : [String: String] = [
            "password": password,
            "newPassword": newPassword
        ]
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let auth = try JSONDecoder().decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    completion(auth)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(User(message: validation.message!.first!))
                    }
                        
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(User(message: "Oops! We don't know what happened there"))
                    }
                }
            }

        }.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (UserAuth) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(authBaseUrl)/login")
        
        let parameters : [String: String] = [
            "email": email,
            "password": password
        ]
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let auth = try JSONDecoder().decode(UserAuth.self, from: data)
                
                DispatchQueue.main.async {
                    completion(auth)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(UserAuth(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(UserAuth(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func refreshTokens(completion: @escaping (UserAuth) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(authBaseUrl)/refresh")
        let refreshToken = TokenService().getToken(key: .refreshToken)
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("refreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let auth = try JSONDecoder().decode(UserAuth.self, from: data)
                
                DispatchQueue.main.async {
                    completion(auth)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(UserAuth(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(UserAuth(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func deauthenticate(completion: @escaping (Bool) -> ()) -> Void {
        do {
            // Remove any stored tokens (this will prevent any future authenticated calls to the API)
            try TokenService().removeToken(key: .accessToken)
            try TokenService().removeToken(key: .refreshToken)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func refreshAccessWithHandling(completion: @escaping (Bool) -> ()) {
        self.refreshTokens() { tokens in
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
}
