//
//  ALWebView.swift
//  ArkoseLabsiOSDemo
//
//  Created by ArkoseLabs on 30/06/2021.
//

import Foundation
import SwiftUI
import UIKit
import WebKit
import CryptoKit
import os
import SystemConfiguration

// MARK: ALWebView
@available(swift, deprecated: 2.0, message: "Use ArkoseChallengeView instead")
public struct ALWebView: UIViewRepresentable {
    
    public struct ArkoseChallengeDelegateImpl : ArkoseChallengeDelegate {
        public func onReady() {
            webEventDelegate?.onReady()
        }
        
        public func onShow() {
            webEventDelegate?.onShow()
        }
        
        public func onShown() {
            webEventDelegate?.onShown()
        }
        
        public func onSuppress() {
            webEventDelegate?.onSuppress()
        }
        
        public func onHide() {
            webEventDelegate?.onHide()
        }
        
        public func onReset() {
            webEventDelegate?.onReset()
        }
        
        public func onCompleted(response: [String : Any?]) {
            webEventDelegate?.onCompleted(response: response )
        }
        
        public func onError(response: [String : Any?]) {
            webEventDelegate?.onError(response: response)
        }
        
        public func onFailed(response: [String : Any?]) {
            webEventDelegate?.onFailed(response: response)
        }
        
        public func onResize(widthValue: CGFloat, heightValue: CGFloat) {
            webEventDelegate?.onResize(widthValue: widthValue, heightValue: heightValue)
        }
        
        public var webEventDelegate: WebEventDelegate?
        
        public init(webEventDelegate: WebEventDelegate) {
            self.webEventDelegate = webEventDelegate
        }
    }
    
    var challengeDelegate: ArkoseChallengeDelegateImpl
    var challengeWebView: ChallengeWebView
    
    public init(apiBlob: String,
                apiLang: String,
                apiKey: String,
                webEventDelegate: WebEventDelegate) {

        // Get any missing params from config
        var apiKey2 = apiKey
        var apiUrlBase = ""
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if apiKey2.isEmpty{
                    apiKey2 = dic["API_KEY"] as! String
                }
                apiUrlBase = dic["API_URL_BASE"] as! String
            }
        }
        
        // Initialize the SDK
        ArkoseManager.initialize(
            with: ArkoseConfig.Builder(withAPIKey: apiKey2)
                    .with(apiBaseUrl: apiUrlBase)
                    .with(language: apiLang)
                    .with(blob: apiBlob)
                    .build()
            )
        
        self.challengeDelegate = ArkoseChallengeDelegateImpl(webEventDelegate: webEventDelegate)
        self.challengeWebView = ChallengeWebView(delegate: self.challengeDelegate, frame: CGRect.zero)
    }
    public func resetSession() {
        self.challengeWebView.resetChallenge()
    }
    public func networkError() {
        self.challengeDelegate.onError(response: [AppConstants.ALCallbackName.onError: AppConstants.ALErrorText.errorNetworkUnavailable])
    }
    public func makeUIView(context: Context) -> UIView {
        return self.challengeWebView
    }
    
    public func updateUIView(_ webView: UIView, context: Context) {
        
    }
    
    public static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        uiView.removeFromSuperview()
    }
}
