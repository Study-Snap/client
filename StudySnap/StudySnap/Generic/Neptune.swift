//
//  Neptune.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-13.
//

import SwiftUI

struct CreateNoteData: Codable {
    enum CodingKeys: String, CodingKey {
        case title, classId, keywords, shortDescription, fileName, fileData, bibtextCitation
    }
    
    var title: String
    var classId: String
    var keywords: [String]
    var shortDescription: String
    var fileName: String
    var fileData: Data
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
        case title, classId, keywords, shortDescription, body, fileUri, authorId, rating, timeLength,  bibtextCitation, message
        
        case id = "id"
    }
    
    var id: Int?
    var title: String?
    var classId: String?
    var keywords: [String]?
    var shortDescription: String?
    var body: String?
    var fileUri: String?
    var authorId: Int?
    var rating: [Int]?
    var timeLength: Int?
    var bibtextCitation: String?
    
    // For errors or other messages
    var statusCode: Int?
    var error: String?
    var message: String?
}

class NeptuneApi {
    let neptuneBaseUrl: String = "\(InfoPlistParser.getStringValue(forKey: Constants.PROTOCOL_KEY))://\(InfoPlistParser.getStringValue(forKey: Constants.NEPTUNE_KEY))"
    
    func createNote(noteData: CreateNoteData, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        self.uploadNoteFile(fileName: noteData.fileName, fileData: noteData.fileData) { res in
            if res.statusCode == 201 && res.fileUri != nil {
                // Successful file upload
                self.createNoteWithFile(noteData: noteData, fileUri: res.fileUri!) { result in
                    if result.message == nil {
                        completion(result)
                    } else {
                        print("[ERROR] \(result.message!)")
                        completion(ApiNoteResponse(error: "Error", message: result.message!))
                    }
                }
            } else {
                // Failed file upload
                print("[ERROR] \(res.message!)")
                completion(ApiNoteResponse(message: "Failed to upload file. \(res.message ?? "No reason specified"). Try again..."))
            }
        }
    }
    
    func createNoteWithFile(noteData: CreateNoteData, fileUri: String, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes")
        
        let parameters: [String: Any] = [
            "title": noteData.title,
            "keywords": noteData.keywords,
            "shortDescription": noteData.shortDescription,
            "fileUri": fileUri,
            // MARK: include bibtextCitation here once it is fixed on the serverside
        ]
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let note: ApiNoteResponse = try JSONDecoder().decode(ApiNoteResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiNoteResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiNoteResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
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
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiFileResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiFileResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func getNoteWithId(noteId: Int, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/\(noteId)")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let note: ApiNoteResponse = try JSONDecoder().decode(ApiNoteResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(ApiNoteResponse(message: "Oops! We don't know what happened there"))
                }
            }
        }.resume()
    }
    
    func getTopNotesByRating(count: Int = 5, completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/top")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let note: [ApiNoteResponse] = try JSONDecoder().decode([ApiNoteResponse].self, from: data)
                
                DispatchQueue.main.async {
                    completion(Array(note.prefix(count)))
                }
            } catch {
                do {
                    let note: ApiNoteResponse = try JSONDecoder().decode(ApiNoteResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion([note])
                    }
                } catch {
                    do {
                        print(error.localizedDescription)
                        let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion([ApiNoteResponse(message: validation.message!.first!)])
                        }
                    } catch {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completion([ApiNoteResponse(message: "Oops! We don't know what happened there")])
                        }
                    }
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
            ],
            "classId": "448f7db0-e3ac-4875-9235-5e08ffa4ed82" //MARK: Implement after classroom features are created
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
                    do {
                        print(error.localizedDescription)
                        let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion([ApiNoteResponse(message: validation.message!.first!)])
                        }
                    } catch {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completion([ApiNoteResponse(message: "Oops! We don't know what happened there")])
                        }
                    }
                }
            }
        }.resume()
    }
}
