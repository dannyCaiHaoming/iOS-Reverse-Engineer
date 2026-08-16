import SwiftUI

struct InsecureStorageLab: View {
    private let tokenKey = "access_token"
    @State private var token = ""
    @State private var message = "No token loaded."

    var body: some View {
        Form {
            Section("Insecure Example") {
                TextField("Token", text: $token)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Button("Save token to UserDefaults") {
                    UserDefaults.standard.set(token, forKey: tokenKey)
                    message = "Saved to UserDefaults. This is not appropriate for sensitive tokens."
                }

                Button("Load token from UserDefaults") {
                    let saved = UserDefaults.standard.string(forKey: tokenKey) ?? ""
                    message = saved.isEmpty ? "No token found." : "Loaded token: \(saved)"
                }

                Button("Clear token") {
                    UserDefaults.standard.removeObject(forKey: tokenKey)
                    token = ""
                    message = "Token cleared."
                }
            }

            Section("Observation") {
                Text(message)
                Text("Security note: UserDefaults is for preferences, not sensitive credentials.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Storage Lab")
    }
}

#Preview {
    NavigationStack {
        InsecureStorageLab()
    }
}
