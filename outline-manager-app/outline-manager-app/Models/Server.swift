//
//  Server.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 09.09.2023.
//

import Foundation
import CoreLocation

struct Server: Codable, Identifiable {
    var id: UUID
    var name: String
    var apiUrl: String
}
