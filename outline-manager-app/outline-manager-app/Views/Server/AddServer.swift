//
//  AddServer.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 05.10.2023.
//

import SwiftUI

struct AddServer: View {
    @Binding var newName: String
    @Binding var newApiUrl: String
    @Binding var isAddingServer: Bool
    
    var onAdd: () -> Void

    var body: some View {
        // TODO: сделать валидацию url
        NavigationView {
            Form {
                Section(header: Text("New server")) {
                    TextField("Server name", text: $newName)
                    TextField("https://server-ip/api-token", text: $newApiUrl)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isAddingServer = false
                },
                trailing: Button("Save") {
                    onAdd()
                    isAddingServer = false
                }
            )
            .navigationBarTitle("Create server")
        }
    }
}

struct AddServer_Previews: PreviewProvider {
    @State static var newName: String = ""
    @State static var newApiUrl: String = ""
    @State static var isAddingServer: Bool = true

    static var previews: some View {
        AddServer(newName: $newName, newApiUrl: $newApiUrl, isAddingServer: $isAddingServer, onAdd: {})
    }
}
