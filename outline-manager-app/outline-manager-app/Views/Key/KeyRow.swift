//
//  KeyRow.swift
//  outline-manager-app
//
//  Created by Кирилл Миль on 11.09.2023.
//

import SwiftUI

struct KeyRow: View {
    var accessKey: AccessKey
    var body: some View {
        HStack{
            Image("serverkey")
            Text(accessKey.name)
            Spacer()
        }
    }
}

struct KeyRow_Previews: PreviewProvider {
    static var previews: some View {
        let key = AccessKey(id: "s", name: "sdada", accessUrl: "sss")
        KeyRow(accessKey: key)
    }
}
