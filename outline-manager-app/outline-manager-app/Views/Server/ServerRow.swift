//
//  ServerRow.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 09.09.2023.
//

import SwiftUI

struct ServerRow: View {
    var server: Server

    var body: some View {
        HStack{
            Image("servericon 1")
            Text(server.name)
            Spacer()
        }
    }
}

struct ServerRow_Previews: PreviewProvider {
    static var previews: some View {
        let server = Server(id: UUID(), name: "Amsterdam", apiUrl: "http://google.com")
        ServerRow(server: server)
    }
}
