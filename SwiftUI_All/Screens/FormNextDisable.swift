//
//  FormNextDisable.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 24/09/25.
//

import SwiftUI

struct FormNextDisable: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var isDisabled: Bool {
        username.count < 5 || password.count < 5
    }
    var body: some View {
        Form {
            Section("Please enter details") {
                TextField("Username", text: $username)
                TextField("Password", text: $password)
            }
            Section {
                HStack {
                    Spacer()
                    Button("Submit") {
                        print("Username: \(username), Password: \(password)")
                    }
                    .disabled(isDisabled)
                    Spacer()
                }
            }
        }
    }
}
#Preview {
    FormNextDisable()
}
