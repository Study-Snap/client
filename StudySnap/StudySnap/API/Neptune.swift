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

struct CreateClassroomData: Codable {
    enum CodingKeys: String, CodingKey {
        case name, thumbnailData, thumbnailUri
    }
    
    var name: String
    var thumbnailData: Data?
    var thumbnailUri: String?
}

struct ApiFileResponse: Codable {
    var statusCode: Int?
    var fileUri: String?
    
    // Info and error messaging
    var message: String?
}

struct ApiRatingResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case value, statusCode, message
        
        case id = "id"
    }
    var id: Int?
    var statusCode: Int?
    var value: Int?
    
    // Info and error messaging
    var message: String?
}
struct ApiClassMessageResponse: Codable {
    var statusCode: Int?

    // Info and error messaging
    var message: String?
}
struct ApiClassroomResponse: Codable, Identifiable{
    enum CodingKeys: String, CodingKey {
        case name, ownerId, thumbnailUri, message
        
        case id = "id"
    }
    var id: String?
    var name: String?
    var ownerId: Int?
    var thumbnailUri: String?
    // For errors or other messages
    var statusCode: Int?
    var error: String?
    var message: String?
}
struct ApiUserId: Codable, Identifiable{
    enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, statusCode, error, message
        
        case id = "id"
    }
    var id: Int?
    var email: String?
    var firstName: String?
    var lastName: String?
    
    // For errors or other messages
    var statusCode: Int?
    var error: String?
    var message: String?
    
}
struct ApiNoteResponse : Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title, classId, keywords, shortDescription, noteAbstract, noteCDN, fileUri, authorId, timeLength, ratings, bibtextCitation, user, message
        
        case id = "id"
    }
    
    var id: Int?
    var title: String?
    var classId: String?
    var keywords: [String]?
    var shortDescription: String?
    var noteAbstract: String?
    var noteCDN: String?
    var fileUri: String?
    var authorId: Int?
    var timeLength: Int?
    var ratings: [RatingModel]?
    var bibtextCitation: String?
    var user: UserModel?
    // For errors or other messages
    var statusCode: Int?
    var error: String?
    var message: String?
}

struct UFileType {
    static let IMAGE = "image"
    static let NOTE  = "note"
}

class NeptuneApi {
    let neptuneBaseUrl: String = "\(InfoPlistParser.getStringValue(forKey: Constants.PROTOCOL_KEY))://\(InfoPlistParser.getStringValue(forKey: Constants.NEPTUNE_KEY))"
    
    func createNote(noteData: CreateNoteData, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        self.uploadFile(fileName: noteData.fileName, fileData: noteData.fileData, fileType: UFileType.NOTE) { res in
            if res.statusCode == 201 && res.fileUri != nil {
                // Successful file upload
                self.createNoteWithFile(noteData: noteData, fileUri: res.fileUri!) { result in
                    if result.message == nil {
                        completion(result)
                    } else {
                        completion(ApiNoteResponse(error: "Error", message: result.message!))
                    }
                }
            } else {
                // Failed file upload
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
            "classId": noteData.classId,
            "fileUri": fileUri,
            "bibtextCitation": noteData.bibtextCitation!
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
    func joinClassroom(classIdData: String,completion: @escaping (ApiClassMessageResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users/classroom/join/\(classIdData)")
        
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let classroom: ApiClassMessageResponse = try JSONDecoder().decode(ApiClassMessageResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(classroom)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    func leaveClassroom(classIdData: String,completion: @escaping (ApiClassMessageResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users/classroom/leave/\(classIdData)")
        
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let classroom: ApiClassMessageResponse = try JSONDecoder().decode(ApiClassMessageResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(classroom)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func createClassroom(data: CreateClassroomData, completion: @escaping (ApiClassroomResponse) -> ()) -> Void {
        if (data.thumbnailData != nil) {
            self.uploadFile(fileName: "image.png", fileData: data.thumbnailData!, fileType: UFileType.IMAGE) { res in
                if res.statusCode == 201 && res.fileUri != nil {
                    // Successful file upload
                    self.createClassroomPostData(data: CreateClassroomData(name: data.name, thumbnailUri: res.fileUri!)) { result in
                        if result.message == nil {
                            completion(result)
                        } else {
                            completion(ApiClassroomResponse(error: "Error", message: result.message!))
                        }
                    }
                } else {
                    // Failed file upload
                    completion(ApiClassroomResponse(message: "Failed to upload file. \(res.message ?? "No reason specified"). Try again..."))
                }
            }
        } else {
            self.createClassroomPostData(data: CreateClassroomData(name: data.name)) { result in
                if result.message == nil {
                    completion(result)
                } else {
                    completion(ApiClassroomResponse(error: "Error", message: result.message!))
                }
            }
        }
    }
    
    func createClassroomPostData(data: CreateClassroomData, completion: @escaping (ApiClassroomResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/classrooms")
        print(data)
        let parameters: [String: Any] = data.thumbnailUri != nil ? [
            "name": data.name,
            "thumbnailUri": data.thumbnailUri!
        ] : ["name": data.name]
        
        print(parameters)
        
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
                let classroom: ApiClassroomResponse = try JSONDecoder().decode(ApiClassroomResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(classroom)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiClassroomResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiClassroomResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func getCurrentUserId(completion: @escaping (ApiUserId) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let user: ApiUserId = try JSONDecoder().decode(ApiUserId.self, from: data)
                
                DispatchQueue.main.async {
                    completion(user)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(ApiUserId(message: "Oops! We don't know what happened there"))
                }
            }
        }.resume()
    }
    
    func getCurrentClassroomOwner(classIdData: String, completion: @escaping (ApiClassroomResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/classrooms/by-uuid/\(classIdData)")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let user: ApiClassroomResponse = try JSONDecoder().decode(ApiClassroomResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(user)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(ApiClassroomResponse(message: "Oops! We don't know what happened there"))
                }
            }
        }.resume()
    }
    
    func uploadFile(fileName: String, fileData: Data, fileType: String, completion: @escaping (ApiFileResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/files/\(fileType)")
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
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/by-id/\(noteId)")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
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
    
    func getAverageNoteRating(noteId: Int, completion: @escaping (ApiRatingResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/by-id/\(noteId)/rating")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let note: ApiRatingResponse = try JSONDecoder().decode(ApiRatingResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(ApiRatingResponse(message: "Oops! We don't know what happened there"))
                }
            }
        }.resume()
    }
    func getUserClassrooms(completion: @escaping ([ApiClassroomResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users/classrooms")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            guard let data = data else { return }
            
            do {
                let classrooms: [ApiClassroomResponse] = try JSONDecoder().decode([ApiClassroomResponse].self, from: data)
                
                DispatchQueue.main.async {
                    completion(classrooms)
                }
            } catch {
                do {
                    let classrooms: ApiClassroomResponse = try JSONDecoder().decode(ApiClassroomResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion([classrooms])
                    }
                } catch let jsonError as NSError {
                    do {
                        print(jsonError.localizedDescription)
                        let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion([ApiClassroomResponse(message: validation.message!.first!)])
                        }
                    } catch {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completion([ApiClassroomResponse(message: "Oops! We don't know what happened there in attempting to load the classrooms")])
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    func getTopNotesByRating(count: Int = 5,classId: String, completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/classrooms/by-uuid/\(classId)/notes/top")
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        
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
    
    func deleteNote(noteId: Int, completion: @escaping (ApiClassMessageResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes")
        print(noteId)
        let parameters: [String: Any] = [
            "noteId": noteId
        ]
        
        print(parameters)
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "DELETE"
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
                let note: ApiClassMessageResponse = try JSONDecoder().decode(ApiClassMessageResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(note)
                }
            } catch {
                do {
                    print(error.localizedDescription)
                    let validation = try JSONDecoder().decode(ValidationError.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: validation.message!.first!))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(ApiClassMessageResponse(message: "Oops! We don't know what happened there"))
                    }
                }
            }
        }.resume()
    }
    
    func getUserNotes(completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users/notes")
        
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(TokenService().getToken(key: .accessToken))", forHTTPHeaderField: "Authorization")
        

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
    func putNoteRating(value: Int, noteId: Int, completion: @escaping (ApiNoteResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/by-id/\(noteId)/rate")
        
        let parameters: [String: Any] = [
            "value": value
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
    
    func getNotesForQuery(query: String,classId: String, completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/notes/search")
        
        let parameters: [String: Any] = [
            "queryType": "query_string",
            "query": [
                "query": query
            ],
            "classId": classId //MARK: Implement after classroom features are created
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
