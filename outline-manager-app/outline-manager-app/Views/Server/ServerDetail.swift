//
//  ServerDetail.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import SwiftUI

struct ServerDetail: View {
    var server: Server
    @State private var accessKeys: [AccessKey] = []

    var body: some View {
        KeyList(accessKeys: $accessKeys, apiUrl: server.apiUrl)
            .onAppear {
                fetchAccessKeys(apiUrl: server.apiUrl) { accsKeys in
                    if let resAccessKeys = accsKeys {
                        accessKeys = resAccessKeys
                    } else {
                        print("Failed to fetch access keys")
                    }
                }
            }
    }
}


struct ServerDetail_Previews: PreviewProvider {
    static var previews: some View {
        ServerDetail(server: Server(id: UUID(), name: "Amstersdam", apiUrl: "https://google.com"))
    }
}

