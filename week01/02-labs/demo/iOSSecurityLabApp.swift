import SwiftUI

@main
struct iOSSecurityLabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    URLSchemeLab.handle(url)
                }
        }
    }
}
