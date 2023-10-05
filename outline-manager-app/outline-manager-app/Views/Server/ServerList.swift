//
//  ServerList.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import SwiftUI

struct ServerList: View {
    @EnvironmentObject var serverManager: ServerManager
    @State private var newName: String = ""
    @State private var newApiUrl: String = ""
    @State private var isAddingServer = false

    func deleteServers(at offsets: IndexSet) {
        for index in offsets {
            let serverForDelete = serverManager.servers[index]
            serverManager.removeServer(withUUID: serverForDelete.id)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(serverManager.servers) { server in
                        NavigationLink {
                           ServerDetail(server: server)
                        } label: {
                            ServerRow(server: server)
                        }
                    }
                    .onDelete(perform: deleteServers)
                }
                .navigationTitle("Servers")
                .navigationBarItems(trailing:
                                        Button(action: {
                    isAddingServer = true // Показать всплывающее окно при нажатии кнопки
                }) {
                    Text("Add new server")
                }
                )
                .sheet(isPresented: $isAddingServer) {
                    AddServer(newName: $newName, newApiUrl: $newApiUrl, isAddingServer: $isAddingServer) {
                        serverManager.addServer(name: newName, apiUrl: newApiUrl)
                        newName = ""
                        newApiUrl = ""
                    }
                }
            }
            .onAppear {
                // Загрузка данных при отображении вью
                serverManager.loadServers()
            }
        }
    }
}

struct ServerList_Previews: PreviewProvider {
    static var previews: some View {
        ServerList()
            .environmentObject(ServerManager())
    }
}
