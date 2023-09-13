//
//  ServerApi.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import Foundation


    
func fetchAccessKeys(apiUrl: String, completion: @escaping ([AccessKey]?) -> Void) {
    guard let url = URL(string: apiUrl + "/access-keys") else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: SkipVerifyDelegate(), delegateQueue: nil)
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let response = try JSONDecoder().decode(AccessKeyResponse.self, from: data)
                completion(response.accessKeys)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    task.resume()
    
}

class SkipVerifyDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Пропустить проверку SSL-сертификата
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}


