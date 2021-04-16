//
//  Neptune.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

struct CreateNoteData: Codable {
    enum CodingKeys: String, CodingKey {
        case title, keywords, shortDescription, fileName, fileData, isPublic, allowDownloads, bibtextCitation
    }
    
    var title: String
    var keywords: [String]
    var shortDescription: String
    var fileName: String
    var fileData: Data
    var isPublic: Bool
    var allowDownloads: Bool
    var bibtextCitation: String?
}

struct ApiFileResponse: Codable {
    var statusCode: Int?
    var fileUri: String?
    
    // Info and error messaging
    var message: String?
}

struct ApiNoteResponse : Codable, Identifiable {
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
    
    func uploadNoteWithData(noteData: CreateNoteData, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        // MARK: Implement full request with data
    }
    
    func uploadNoteFile(fileName: String, fileData: Data, completion: @escaping (ApiFileResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/files")
        let reqFileParamName: String = "file"
        let boundary: String = UUID().uuidString
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var reqData: Data = Data()
        
        // Attach the PDF file data to the raw request data
        reqData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        reqData.append("Content-Disposition: form-data; name=\"\(reqFileParamName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        reqData.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        reqData.append(fileData)
        reqData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set request data in httpbody
        request.httpBody = reqData
        
        // Make the request and get response details
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let file: ApiFileResponse = try JSONDecoder().decode(ApiFileResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(file)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(ApiFileResponse(message: "Oops! We don't know what happened there"))
                }
            }
        }.resume()
    }
    
    func getNotesForQuery(query: String, completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
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
                let note: [ApiNoteResponse] = try JSONDecoder().decode([ApiNoteResponse].self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                do {
                    let note: ApiNoteResponse = try JSONDecoder().decode(ApiNoteResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion([note])
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion([ApiNoteResponse(message: "Oops! We don't know what happened there")])
                    }
                }
            }
        }.resume()
    }
}
