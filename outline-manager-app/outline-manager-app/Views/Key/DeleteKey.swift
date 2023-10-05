//
//  DeleteKey.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 04.10.2023.
//

import SwiftUI

struct DeleteKey: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void
    
    
    var body: some View {
        EmptyView()
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text("Delete key"),
                    message: Text("Are you sure you want to delete this key?"),
                    primaryButton: .destructive(Text("Delete")) {
                        onDelete()
                        isPresented = false
                    },
                    secondaryButton: .cancel {
                        isPresented = false
                    }
                )
            }
    }
}

struct DeleteKey_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        DeleteKey(isPresented: $isPresented, onDelete: {})
    }
}
