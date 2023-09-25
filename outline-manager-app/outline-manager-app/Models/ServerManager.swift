//
//  ModelData.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import Foundation
import Combine


final class ServerManager: ObservableObject {
    @Published var servers: [Server] = []
    
    func addServer(name: String, apiUrl: String) {
        let newServer = Server(id: UUID(), name: name, apiUrl: apiUrl)
        servers.append(newServer)
        saveServers()
    }
    
    func removeServer(withUUID uuid: UUID) {
        if let index = servers.firstIndex(where: { $0.id == uuid }) {
            servers.remove(at: index)
            saveServers()
        }
    }
    
    private func saveServers() {
        if let encodedData = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(encodedData, forKey: "savedServers")
        }
    }
    
    private func loadServers() {
        if let savedData = UserDefaults.standard.data(forKey: "savedServers"),
           let decodedServers = try? JSONDecoder().decode([Server].self, from: savedData) {
            servers = decodedServers
        }
    }
}
