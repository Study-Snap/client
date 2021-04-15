//
//  Neptune.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

struct ApiNote : Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title, keywords, shortDescription, body, fileUri, authorId, rating, timeLength, isPublic, allowDownloads, bibtextCitation, message
        
        case id = "_id"
    }
    
    var id: Int?
    var title: String?
    var keywords: [String]?
    var shortDescription: String?
    var body: String?
    var fileUri: String?
    var authorId: Int?
    var rating: [Int]?
    var timeLength: Int?
    var isPublic: Bool?
    var allowDownloads: Bool?
    var bibtextCitation: String?
    
    // For errors or other messages
    var message: String?
}

class NeptuneApi {
    let neptuneBaseUrl: String = "https://studysnap.ca/neptune"
    
    func getNotesForQuery(query: String, completion: @escaping ([ApiNote]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/search")
        
        let parameters: [String: Any] = [
            "queryType": "query_string",
            "query": [
                "query": query
            ]
        ]
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let note: [ApiNote] = try JSONDecoder().decode([ApiNote].self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                do {
                    let note: ApiNote = try JSONDecoder().decode(ApiNote.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion([note])
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion([ApiNote(message: "Oops! We don't know what happened there")])
                    }
                }
            }
        }.resume()
    }
}
