//
//  WebVideoView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import SwiftUI
import WebKit

struct WebVideoView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: url))
    }
}
