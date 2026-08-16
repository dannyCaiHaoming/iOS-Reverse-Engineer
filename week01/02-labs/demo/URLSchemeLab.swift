import SwiftUI
import UIKit

enum URLSchemeLab {
    static var lastURL: String = "No URL opened yet."

    static func handle(_ url: URL) {
        lastURL = url.absoluteString

        guard url.scheme == "securitylab" else {
            print("Unexpected scheme: \(url.scheme ?? "nil")")
            return
        }

        print("Received URL: \(url.absoluteString)")
        print("Host: \(url.host ?? "nil")")
        print("Query: \(url.query ?? "nil")")
    }
}

struct URLSchemeLabView: View {
    @State private var exampleURL = "securitylab://open?token=demo-token"

    var body: some View {
        Form {
            Section("Example URL") {
                Text(exampleURL)
                    .font(.system(.body, design: .monospaced))

                Button("Copy example URL") {
                    UIPasteboard.general.string = exampleURL
                }
            }

            Section("Security Notes") {
                Text("URL Scheme is an external input boundary. Do not pass sensitive tokens in URLs.")
                Text("Always validate scheme, host, path, and query parameters before routing.")
            }
        }
        .navigationTitle("URL Scheme Lab")
    }
}

#Preview {
    NavigationStack {
        URLSchemeLabView()
    }
}
