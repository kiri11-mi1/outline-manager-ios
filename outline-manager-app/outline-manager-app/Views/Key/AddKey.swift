//
//  AddKey.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 05.10.2023.
//

import SwiftUI

struct AddKey: View {
    @Binding var isAddingKey: Bool
    @Binding var newName: String
    var onAdd: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Key name")) {
                    TextField("Amsterdam", text: $newName)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isAddingKey = false // Закрыть окно добавления
                },
                trailing: Button("Save") {
                    onAdd()
                    isAddingKey = false
                }
            )
            .navigationBarTitle("New key")
        }
    }
}

struct AddKey_Previews: PreviewProvider {
    @State static var isAddingKey = true
    @State static var newName = ""
    static var previews: some View {
        AddKey(isAddingKey: $isAddingKey, newName: $newName, onAdd: {})
    }
}
