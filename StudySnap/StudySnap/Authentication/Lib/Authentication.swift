//
//  Authentication.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-03.
//

import SwiftUI

struct User : Codable {
    var _id : Int
    var firstName: String
    var lastName: String
    var email: String
    var accessToken: String?
    var createdAt : String?
    var updatedAt : String?
}

class AuthApi {
    let authBaseUrl: String = "https://studysnap.ca/auth"
    @State var isLoggedIn: Bool = false
    
    func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (User) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(authBaseUrl)/register")
        
        let parameters : [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
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
            
            let user = try! JSONDecoder().decode(User.self, from: data)
            
            DispatchQueue.main.async {
                completion(user)
            }
        }.resume()
    }
}
