//
//  WebView.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-06-01.
//

import Foundation
import SwiftUI
import WebKit

struct WebView : UIViewRepresentable{
    
    let url : URL
    
    func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            DispatchQueue.main.async {
                let request = URLRequest(url: url)
                webView.load(request)
            }
            return webView
        }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
}
