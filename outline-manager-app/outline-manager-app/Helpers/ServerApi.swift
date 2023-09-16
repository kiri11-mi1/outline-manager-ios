//
//  ServerApi.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import Foundation
import Combine


class SkipVerifyDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Пропустить проверку SSL-сертификата
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}


    
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

func deleteAccessKey(apiUrl: String, keyId: String, completion: @escaping (String?) -> Void) {
    guard let url = URL(string: apiUrl + "/access-keys/" + keyId) else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: SkipVerifyDelegate(), delegateQueue: nil)
    request.httpMethod = "DELETE"
    
    let task = session.dataTask(with: request) { _, _, _ in
        completion(keyId)
    }
    
    task.resume()
    
}


func createAccessKey(apiUrl: String, completion: @escaping (AccessKey?) -> Void) {
    guard let url = URL(string: apiUrl + "/access-keys") else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: SkipVerifyDelegate(), delegateQueue: nil)
    request.httpMethod = "POST"
    
    let task = session.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let response = try JSONDecoder().decode(AccessKey.self, from: data)
                completion(response)
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

func updateAccessKeyName(apiUrl: String, existingKey: AccessKey, newName: String, completion: @escaping (AccessKey?) -> Void) {
    guard let url = URL(string: apiUrl + "/access-keys/" + existingKey.id + "/name") else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: SkipVerifyDelegate(), delegateQueue: nil)
    request.httpMethod = "PUT"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    let updatedKey = AccessKey(id: existingKey.id, name: newName, accessUrl: existingKey.accessUrl)

    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(updatedKey)
        request.httpBody = jsonData
    } catch {
        print("Error encoding JSON: \(error)")
        completion(nil)
        return
    }
    
    let task = session.dataTask(with: request) { data, response, _ in
        completion(updatedKey)
    }

    task.resume()
}


func createNewKeyWithName(apiUrl: String, name: String, completion: @escaping (AccessKey?) -> Void) {
    createAccessKey(apiUrl: apiUrl) { createdAccessKey in
        if let createdAccessKey = createdAccessKey {
            updateAccessKeyName(apiUrl: apiUrl, existingKey: createdAccessKey, newName: name) { updatedAccessKey in
                if let updatedAccessKey = updatedAccessKey {
                    completion(updatedAccessKey)
                }
                else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
