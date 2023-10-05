//
//  EditKey.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 05.10.2023.
//

import SwiftUI

struct EditKey: View {
    @Binding var isEditingName: Bool
    @Binding var editingKeyName: String
    var onEdit: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit key name")) {
                    TextField("Type a new value", text: $editingKeyName)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isEditingName = false
                },
                trailing: Button("Save") {
                    onEdit()
                    isEditingName = false
                }
            )
            .navigationBarTitle("Edit key name")
        }
        
    }
}

struct EditKey_Previews: PreviewProvider {
    @State static var isEditingName = true
    @State static var editingKeyName = "Test"
    static var previews: some View {
        EditKey(isEditingName: $isEditingName, editingKeyName: $editingKeyName, onEdit: {})
    }
}
