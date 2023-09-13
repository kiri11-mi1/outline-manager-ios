//
//  ServerDetail.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import SwiftUI

struct ServerDetail: View {
//    @EnvironmentObject var serverManager: ServerManager
    var server: Server
    
    @State private var accessKeys: [AccessKey] = []
    
    
    @State private var selectedAccessKey: AccessKey?
    @State private var showingActionSheet = false
    @State private var showingDeleteAlert = false
    
    @State private var isAddingKey = false
    @State private var newName: String = ""

    
    var body: some View {
        NavigationView {
            
            VStack {
                // Отобразите информацию о сервере
                Text("\(server.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("AccentColor"))
    //            Text("API URL: \(server.apiUrl)")
                
                // Отобразите информацию о доступных ключах
                if !accessKeys.isEmpty {
                    ForEach(accessKeys, id: \.id) { accessKey in
                        KeyRow(accessKey: accessKey)
                            .onTapGesture {
                                selectedAccessKey = accessKey
                                showingActionSheet = true
                            }
                            .padding()
                    }
                } else {
                    Text("No Access Keys Available")
                }
            }
            .onAppear {
                fetchAccessKeys(apiUrl: server.apiUrl) { accsKeys in
                    if let resAccessKeys = accsKeys {
                        // Ваши действия с полученным списком ключей
                        accessKeys = resAccessKeys
                    } else {
                        print("Failed to fetch access keys")
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Выберите действие"),
                    buttons: [
                        .default(Text("Изменить")) {
                            // Добавьте код для редактирования ключа
                        },
                        .default(Text("Копировать ссылку")) {
                            if let selectedAccessKey = selectedAccessKey {
                                // Копируйте ссылку в буфер обмена
                                UIPasteboard.general.string = selectedAccessKey.accessUrl
                            }
                        },
                        .destructive(Text("Удалить")) {
                            showingDeleteAlert = true
                        },
                        .cancel()
                    ]
                )
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Удалить ключ"),
                    message: Text("Вы уверены, что хотите удалить этот ключ?"),
                    primaryButton: .destructive(Text("Удалить")) {
                        if let selectedAccessKey = selectedAccessKey {
                            // Добавьте код для удаления ключа из массива accessKeys
                            print("Delete request for key:", selectedAccessKey)
//                            accessKeys.removeAll { $0.id == selectedAccessKey.id }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            .navigationBarItems(trailing:
                                    Button(action: {
                isAddingKey = true // Показать всплывающее окно при нажатии кнопки
            }) {
                Text("Добавить новый ключ")
            }
            )
            .sheet(isPresented: $isAddingKey) {
                // TODO: сделать в отдельной вьюхе
                // TODO: сделать валидацию url
                
                NavigationView {
                    Form {
                        Section(header: Text("Название ключа")) {
                            TextField("Амстердам", text: $newName)
                                .autocapitalization(.none)
                        }
                    }
                    .navigationBarItems(
                        leading: Button("Отмена") {
                            isAddingKey = false // Закрыть окно добавления
                        },
                        trailing: Button("Добавить") {
                            print("request to create")
                            newName = ""
                            isAddingKey = false // Закрыть окно добавления
                        }
                    )
                    .navigationBarTitle("Добавить ключ")
                }
            }
            
        }
    
    }
}

struct ServerDetail_Previews: PreviewProvider {
    static let servManager = ServerManager()
    
    static var previews: some View {
        ServerDetail(server: Server(id: UUID(), name: "Amstersdam", apiUrl: "https://google.com"))
    }
}

