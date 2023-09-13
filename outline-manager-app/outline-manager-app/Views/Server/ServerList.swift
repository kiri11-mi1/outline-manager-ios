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
                }
                .navigationTitle("Servers")
                .navigationBarItems(trailing:
                                        Button(action: {
                    isAddingServer = true // Показать всплывающее окно при нажатии кнопки
                }) {
                    Text("Добавить новый сервер")
                }
                )
                .sheet(isPresented: $isAddingServer) {
                    // TODO: сделать в отдельной вьюхе
                    // TODO: сделать валидацию url
                    
                    NavigationView {
                        Form {
                            Section(header: Text("Новый сервер")) {
                                TextField("Наименование сервера", text: $newName)
                                TextField("http://", text: $newApiUrl)
                                    .autocapitalization(.none)
                            }
                        }
                        .navigationBarItems(
                            leading: Button("Отмена") {
                                isAddingServer = false // Закрыть окно добавления
                            },
                            trailing: Button("Добавить") {
                                serverManager.addServer(name: newName, apiUrl: newApiUrl)
                                newName = ""
                                newApiUrl = ""
                                isAddingServer = false // Закрыть окно добавления
                            }
                        )
                        .navigationBarTitle("Добавить сервер")
                    }
                }
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
