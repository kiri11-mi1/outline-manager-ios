//
//  ContentView.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 02.09.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ServerList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ServerManager())
    }
}
