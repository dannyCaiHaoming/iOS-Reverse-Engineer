import Foundation
import Security
import SwiftUI

enum SecurityLabKeychain {
    static func save(_ value: String, service: String, account: String) -> OSStatus {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        return SecItemAdd(attributes as CFDictionary, nil)
    }

    static func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    static func delete(service: String, account: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        return SecItemDelete(query as CFDictionary)
    }
}

struct KeychainLabView: View {
    private let service = "com.example.iossecuritylab.auth"
    private let account = "access_token"

    @State private var token = ""
    @State private var message = "No Keychain operation yet."

    var body: some View {
        Form {
            Section("Keychain Example") {
                TextField("Token", text: $token)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Button("Save token to Keychain") {
                    let status = SecurityLabKeychain.save(token, service: service, account: account)
                    message = "Save status: \(status)"
                }

                Button("Read token from Keychain") {
                    let saved = SecurityLabKeychain.read(service: service, account: account)
                    message = saved.map { "Loaded token: \($0)" } ?? "No token found."
                }

                Button("Delete token") {
                    let status = SecurityLabKeychain.delete(service: service, account: account)
                    token = ""
                    message = "Delete status: \(status)"
                }
            }

            Section("Observation") {
                Text(message)
                Text("Security note: Keychain is better suited for credentials, but access control choices still matter.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Keychain Lab")
    }
}

#Preview {
    NavigationStack {
        KeychainLabView()
    }
}
