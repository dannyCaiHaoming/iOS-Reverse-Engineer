import SwiftUI
import WebKit

struct WebViewBridgeLab: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("WKWebView JSBridge Demo")
                .font(.headline)

            SecurityLabWebView()
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text("Security note: JSBridge connects web input to native code. Keep exposed methods minimal and validate all input.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .navigationTitle("WebView Lab")
    }
}

struct SecurityLabWebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "securityLab")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.loadHTMLString(Self.html, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "securityLab" else {
                return
            }

            print("JSBridge message: \(message.body)")
        }
    }

    private static let html = """
    <!doctype html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <style>
          body { font-family: -apple-system; padding: 20px; }
          button { font-size: 17px; padding: 12px; }
          code { background: #eee; padding: 2px 4px; }
        </style>
      </head>
      <body>
        <h3>JSBridge Test Page</h3>
        <p>This page calls native code through <code>window.webkit.messageHandlers.securityLab</code>.</p>
        <button onclick="sendMessage()">Send Message To Native</button>
        <script>
          function sendMessage() {
            window.webkit.messageHandlers.securityLab.postMessage({
              action: "demo",
              value: "hello-from-webview"
            });
          }
        </script>
      </body>
    </html>
    """
}

#Preview {
    NavigationStack {
        WebViewBridgeLab()
    }
}
