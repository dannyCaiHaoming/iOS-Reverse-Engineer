import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Week 01 Labs") {
                    NavigationLink("Insecure Storage Lab") {
                        InsecureStorageLab()
                    }

                    NavigationLink("Keychain Lab") {
                        KeychainLabView()
                    }

                    NavigationLink("URL Scheme Lab") {
                        URLSchemeLabView()
                    }

                    NavigationLink("WebView Bridge Lab") {
                        WebViewBridgeLab()
                    }
                }
            }
            .navigationTitle("iOS Security Lab")
        }
    }
}

#Preview {
    ContentView()
}
