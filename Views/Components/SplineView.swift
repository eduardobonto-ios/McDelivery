//
//  SplineView.swift
//  McdDelivery
//
//  Created by Mac on 2025-12-17.
//


import SwiftUI
import WebKit

struct SplineView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No-op
    }
}
