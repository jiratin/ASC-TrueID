//
//  ShelfHeader.swift
//  AmityUIKit4
//
//  Created by Thavorn Kamolsin on 9/11/2567 BE.
//

import SwiftUI
@preconcurrency import WebKit

struct ShelfHeader: View {
    @EnvironmentObject var dataSource: DataSource
    @State private var shouldOpenExternal = false
    @State private var webViewHeight: CGFloat = 0
    
    var body: some View {
        WebView(
            url: URL(string: AmityUIKitManagerInternal.shared.urlAdvertisement)!,
            shouldOpenExternal: $shouldOpenExternal,
            webViewHeight: $webViewHeight
        )
        .frame(height: webViewHeight)
        .onAppear() {
            if !dataSource.isFirstLoadWeb {
                dataSource.isHidenShelf = true
                dataSource.isFirstLoadWeb = true
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    @EnvironmentObject var dataSource: DataSource
    let url: URL
    @Binding var shouldOpenExternal: Bool
    @Binding var webViewHeight: CGFloat

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let contentHeight = webView.scrollView.contentSize.height
            parent.webViewHeight = contentHeight
            parent.dataSource.isHidenShelf = false
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                parent.shouldOpenExternal = true
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

#Preview {
    ShelfHeader()
}
