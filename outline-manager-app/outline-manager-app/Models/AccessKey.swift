//
//  AccessKey.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import Foundation


struct AccessKey: Codable {
    var id: String
    var name: String
    var accessUrl: String
}

struct AccessKeyResponse: Codable {
    var accessKeys: [AccessKey]
}
