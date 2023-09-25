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
    
    
    @State private var selectedAccessKey: AccessKey?
    @State private var showingActionSheet = false
    @State private var showingDeleteAlert = false
    
    @State private var isAddingKey = false
    @State private var newName: String = ""
    
    @State private var editingKeyName: String = ""
    @State private var isEditingName = false

    var body: some View {
        NavigationView {
            VStack {
                // Отобразите информацию о сервере
                Text("\(server.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("AccentColor"))
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
                            if let selectedAccessKey = selectedAccessKey {
                                editingKeyName = selectedAccessKey.name
                                isEditingName = true
                            }
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
                            deleteAccessKey(apiUrl: server.apiUrl, keyId: selectedAccessKey.id) { keyId in
                                if let keyId = keyId {
                                    // Обработка ошибки при удалении ключа
                                    print("Key \(keyId) deleted successfully")
                                    accessKeys.removeAll { $0.id == selectedAccessKey.id }
                                } else {
                                    // Успешно удалено
                                    print("Error deleting key")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $isEditingName) {
                NavigationView {
                    Form {
                        Section(header: Text("Изменить имя ключа")) {
                            TextField("Введите новое название", text: $editingKeyName)
                                .autocapitalization(.none)
                        }
                    }
                    .navigationBarItems(
                        leading: Button("Отмена") {
                            isEditingName = false
                        },
                        trailing: Button("Сохранить") {
                            if let selectedAccessKey = selectedAccessKey {
                                updateAccessKeyName(apiUrl: server.apiUrl, existingKey: selectedAccessKey, newName: editingKeyName) { updatedAccessKey in
                                    if let updatedAccessKey = updatedAccessKey {
                                       if let index = accessKeys.firstIndex(where: { $0.id == selectedAccessKey.id }) {
                                           accessKeys[index] = updatedAccessKey
                                       }
                                        isEditingName = false
                                    }
                                }
                            }
                        }
                    )
                    .navigationBarTitle("Изменить имя ключа")
                }
            }
            
            .navigationBarItems(trailing:
                                    Button(action: {
                isAddingKey = true
            }) {
                Text("Добавить новый ключ")
            }
            )
            .sheet(isPresented: $isAddingKey) {
                
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
                            createNewKeyWithName(apiUrl: server.apiUrl, name: newName) { newKey in
                                if let newKey = newKey {
                                    newName = ""
                                    isAddingKey = false // Закрыть окно добавления
                                    accessKeys.append(newKey)
                                    print("key was added", newKey)
                                }
                                else{
                                    print("key was not added")
                                }
                            }
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

