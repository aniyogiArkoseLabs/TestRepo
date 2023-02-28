//
//  WebView.swift
//  ArkoseLabsiOSDemo
//
//  Created by ArkoseLabs on 26/07/2021.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: URL

    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
}

