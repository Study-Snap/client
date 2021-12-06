//
//  Network.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-11-19.
//

import Foundation



class Spaces {
    private let spacesBaseUrl: String = "https://\(InfoPlistParser.getStringValue(forKey: Constants.NOTE_SPACES_EP_KEY))"
    
    func getNoteDataFromCDN(fileId: String, completion: @escaping (Data?) -> ()) -> Void {
        let reqUrl: URL! = URL(string: "\(spacesBaseUrl)/\(fileId)")
        
        
        var request: URLRequest = URLRequest(url: reqUrl)
        request.httpMethod = "GET"
        request.setValue("application/pdf", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {(data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
