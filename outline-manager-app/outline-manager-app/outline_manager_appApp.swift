//
//  outline_manager_appApp.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 02.09.2023.
//

import SwiftUI

@main
struct outline_manager_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ServerManager())
        }
    }
}
