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

struct CreateClassroom: Codable {
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

struct ApiClassMessageResponse: Codable {
    var statusCode: Int?

    // Info and error messaging
    var message: String?
}
struct ApiClassroomResponse: Codable, Identifiable{
    enum CodingKeys: String, CodingKey {
        case name, ownerId, message
        
        case id = "id"
    }
    var id: String?
    var name: String?
    var ownerId: Int?
    
    // For errors or other messages
    var statusCode: Int?
    var error: String?
    var message: String?
    
}
struct ApiUserId: Codable, Identifiable{
    enum CodingKeys: String, CodingKey {
        case email,firstName,lastName
        
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
        case title, classId, keywords, shortDescription, body, fileUri, authorId, rating, timeLength,  bibtextCitation, user, message
        
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
    var user: UserModel?
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
    
    func createClassroom(classNameData: String,completion: @escaping (ApiClassroomResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/classrooms")
        
        let parameters: [String: Any] = [
            "name": classNameData
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
    
    func deleteClassroom(classIdData: String,completion: @escaping (ApiClassMessageResponse) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/classrooms")
        
        let parameters: [String: Any] = [
            "classId": classIdData
        ]
        
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
                } catch {
                    do {
                        print(error.localizedDescription)
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
    
    func getUserNotes(completion: @escaping ([ApiNoteResponse]) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(neptuneBaseUrl)/users/notes")
        
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
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
