//
//  KeyList.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 04.10.2023.
//

import SwiftUI

struct KeyList: View {
    
    @Binding var accessKeys: [AccessKey]
    var apiUrl: String
    
    @State private var selectedAccessKey: AccessKey?

    @State private var showingActionSheet = false
    @State private var showingDeleteAlert = false

    @State private var isEditingName: Bool = false
    @State private var isAddingKey: Bool = false

    @State private var newName: String = ""
    @State private var editingKeyName: String = ""

    
    var body: some View {
        NavigationView{
            VStack {
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
                    Text("No access keys available :c")
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Select an action for key"),
                    buttons: [
                        .default(Text("Edit")) {
                            if let key = selectedAccessKey {
                                editingKeyName = key.name
                                isEditingName = true
                            }
                        },
                        .default(Text("Copy access url")) {
                            if let key = selectedAccessKey {
                                UIPasteboard.general.string = key.accessUrl
                            }
                        },
                        .destructive(Text("Delete")) {
                            showingDeleteAlert = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingDeleteAlert) {
                DeleteKey(isPresented: $showingDeleteAlert) {
                    if let selectedAccessKey = selectedAccessKey {
                        deleteAccessKey(apiUrl: apiUrl, keyId: selectedAccessKey.id) { keyId in
                            if let keyId = keyId {
                                print("Key \(keyId) deleted successfully")
                                accessKeys.removeAll { $0.id == selectedAccessKey.id }
                            } else {
                                print("Error deleting key")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isEditingName) {
                EditKey(isEditingName: $isEditingName, editingKeyName: $editingKeyName) {
                    if let key = selectedAccessKey {
                        updateAccessKeyName(apiUrl: apiUrl, existingKey: key, newName: editingKeyName) { updatedAccessKey in
                            if let updatedKey = updatedAccessKey {
                                if let index = accessKeys.firstIndex(where: { $0.id == key.id }) {
                                    accessKeys[index] = updatedKey
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing: Button(
                action: {isAddingKey = true}
            ) {
                Text("Add key")
            })
            .sheet(isPresented: $isAddingKey) {
                AddKey(isAddingKey: $isAddingKey, newName: $newName){
                    createNewKeyWithName(apiUrl: apiUrl, name: newName) { newKey in
                        if let key = newKey {
                            newName = ""
                            accessKeys.append(key)
                            print("key was added", key)
                        }
                        else {
                            print("key was not added")
                        }
                    }
                    
                }
            }
        }
    }
}

struct KeyList_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var prewiewKeyList: [AccessKey] = [
            AccessKey(id: "test", name: "test", accessUrl: "http://google.com"),
            AccessKey(id: "test2", name: "test2", accessUrl: "http://google2.com")
        ]

        KeyList(accessKeys: $prewiewKeyList, apiUrl: "https://ip/token")
    }
}
