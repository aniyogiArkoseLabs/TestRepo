//
//  ChallengeWebView.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 02/11/22.
//

import UIKit
import WebKit
import SystemConfiguration


@available(iOSApplicationExtension, unavailable)
final class ChallengeWebView: UIView, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    // UI Components
    private var webView: WKWebView
    private var activityIndicator: UIActivityIndicatorView
    
    private var widthAnchorConstraint: NSLayoutConstraint?
    private var heightAnchorConstraint: NSLayoutConstraint?
    
    // Delegates
    private var challengeDelegate: ArkoseChallengeDelegate?
    private var vcDelegate: ChallengeVCDelegate?
    
    convenience init(delegate: ArkoseChallengeDelegate, frame: CGRect) {
        self.init(frame: frame)
        self.challengeDelegate = delegate
        self.configureWebView()
        self.configureActivityIndicator()
    }
    override init(frame: CGRect) {
        self.webView = WKWebView(frame: frame)
        self.activityIndicator = UIActivityIndicatorView()
        super.init(frame: frame)
    }
    func setChallengeVCDelegate(delegate: ChallengeVCDelegate) {
        self.vcDelegate = delegate
    }
    func configureActivityIndicator() {
        //self.activityIndicator.backgroundColor = UIColor.red
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = .large
        self.insertSubview(activityIndicator, aboveSubview: self.webView)
        self.activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }

    func configureWebView() {
        //self.webView.backgroundColor = UIColor.green
        // Enable javascript in WKWebView
        if #available(iOS 14.5, *) {
            let wPreferences = WKWebpagePreferences()
            wPreferences.allowsContentJavaScript = true
            self.webView.configuration.defaultWebpagePreferences = wPreferences
        } else {
            // Fallback on earlier versions
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            self.webView.configuration.preferences = preferences
        }
        self.webView.configuration.userContentController.add(self, name: ECConstants.MessageHandler.eventName)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = false
        self.webView.scrollView.isScrollEnabled = true
        self.webView.allowsLinkPreview = false
        self.webView.isMultipleTouchEnabled = false
        self.webView.isUserInteractionEnabled = true
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        self.loadUI()
        self.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.widthAnchorConstraint = self.webView.widthAnchor.constraint(equalTo: self.widthAnchor)
        self.widthAnchorConstraint?.isActive = true
        //Some constant value is needed here
        self.heightAnchorConstraint = self.webView.heightAnchor.constraint(equalToConstant: 317)
        self.heightAnchorConstraint?.isActive = true
        self.topAnchor.constraint(equalTo: self.webView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.webView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadUI() {
        var contentTemplate: String?
        
        if let frameworkBundle = Bundle(identifier: "ArkoseLabs.ArkoseLabsKit") {
            let filePath = frameworkBundle.path(forResource: "ArkoseLabsAPI", ofType: "html")
            let contentData = FileManager.default.contents(atPath: filePath!)
            contentTemplate = String(data: contentData!, encoding: String.Encoding.utf8)
        }
        else {
            if let bundlePath = Bundle.main.path(forResource: "ArkoseLabsKitResource", ofType: "bundle") {
                let resourceBundle = Bundle(path: bundlePath)!
                if let fileURL = resourceBundle.url(forResource: "ArkoseLabsAPI", withExtension: "html") {
                    // we found the file in our bundle!
                    contentTemplate = try! String(contentsOf: fileURL)
                }
            }
        }
        // Load the HTML to be used for the Arkose API and challenge into the webview
        
        var newHtmlContent : String?
        guard let config = ArkoseManagerImpl.shared.config else {
            return
        }
        
        let jsUrl = "\(config.apiBaseUrl)/\(config.apiKey)/\(config.apiJsFile)"
        
        newHtmlContent = contentTemplate?.replacingOccurrences(of: "source", with: jsUrl)
        if (config.blob != nil) {
            newHtmlContent = newHtmlContent?.replacingOccurrences(of: "blob: \"\"",
                                                                  with: "blob: \"\(config.blob!)\"")
        }
        if (config.language != nil) {
            newHtmlContent = newHtmlContent?.replacingOccurrences(of: "language: \'\',",
                                                                  with: "language: \'\(config.language!)\',")
        }
        
        webView.loadHTMLString(newHtmlContent!, baseURL:nil)
//        if let url = frameworkBundle?.url(forResource: "ArkoseLabsAPI",
//                                          withExtension: "html",
//                                          subdirectory: "") {
//            webView.loadHTMLString(newHtmlContent!, baseURL: url.deletingPathExtension())
//        } else {
//            fatalError()
//        }
        return
    }
    
    func updateLayout(height: CGFloat) {
        if( self.heightAnchorConstraint != nil) {
            self.webView.removeConstraint(self.heightAnchorConstraint!)
        }
        self.heightAnchorConstraint = self.webView.heightAnchor.constraint(equalToConstant: height)
        self.heightAnchorConstraint?.isActive = true
    }
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    func calculateSize(response: [String: Any?]) -> (widthValue: CGFloat, heightValue: CGFloat)? {
        Logger.info("calculateSize Param: \(response)")
        let screenWidth = UIScreen.main.bounds.width
        var widthWithUnits : String = ""
        var heightWithUnits : String = ""
        var minWidth : CGFloat = 0.0
        var maxWidth : CGFloat = 0.0
        var viewWidth : CGFloat = 0.0
        var widthValue : CGFloat = 0.0
        for (key, value) in response {
            // Getting the CGFloat value dropping suffices
            if key == "minWidth" {
                minWidth = CGFloat(truncating: NumberFormatter().number(from: String((value as! String).dropLast(2)))!)
            }
            else if key == "maxWidth" {
                maxWidth = CGFloat(truncating: NumberFormatter().number(from: String((value as! String).dropLast(2)))!)
            }
            // Directly getting the string as the suffices will be removed as required
            else if key == "width" {
                widthWithUnits = value as! String
            }
            else if key == "height" {
                heightWithUnits = value as! String
            }
        }
        if screenWidth < minWidth {
            viewWidth = minWidth
        } else
        if screenWidth > maxWidth {
            viewWidth = maxWidth
        }
        else {
            viewWidth = screenWidth
        }
        
        if widthWithUnits.hasSuffix("vw") {
            widthValue = NumberFormatter().number(from: String(widthWithUnits.dropLast(2))) as! CGFloat * viewWidth / 100
        } else
        if widthWithUnits.hasSuffix("%") {
            widthValue = NumberFormatter().number(from: String(widthWithUnits.dropLast(1))) as! CGFloat * viewWidth / 100
        } else
        if widthWithUnits.hasSuffix("px") {
            widthValue = NumberFormatter().number(from: String(widthWithUnits.dropLast(2))) as! CGFloat
        }
        else {
            return nil
        }
        guard let heightValue  = NumberFormatter().number(from: String(heightWithUnits.dropLast(2))) as? CGFloat
        else{
            return nil
        }
        Logger.info("calculateSize: Width=\(widthValue), Height=\(heightValue)")
        return (widthValue, heightValue)
    }
    
    func onReady() {
        challengeDelegate?.onReady()
    }
    
    func onShow() {
        challengeDelegate?.onShow()
    }
    
    func onShown() {
        challengeDelegate?.onShown()
        vcDelegate?.shown()

    }
    
    func onSupress() {
        challengeDelegate?.onSuppress()
    }
    
    func onHide() {
        challengeDelegate?.onHide()
    }
    
    func onReset() {
        challengeDelegate?.onReset()
    }
    
    func onResize(response: [String: Any?]) {
        if let size = calculateSize(response: response) {
            challengeDelegate?.onResize(widthValue: size.widthValue, heightValue: size.heightValue)
            vcDelegate?.resize(widthValue: size.widthValue, heightValue: size.heightValue)
        }
    }
    
    func onCompleted(response: [String: Any?]) {
        challengeDelegate?.onCompleted(response: response)
        vcDelegate?.dismiss(animated: true)
    }
    
    func onError(response: [String: Any?]) {
        challengeDelegate?.onError(response: response)
        vcDelegate?.dismiss(animated: true)
    }
    
    func onFailed(response: [String: Any?]) {
        challengeDelegate?.onFailed(response: response)
        vcDelegate?.dismiss(animated: true)
    }
    
    func onDataRequest(response: [String: [String: String]]) {
        
        var fpData = [String:Any]()
        do {
            try fpData = ArkoseManagerImpl.shared.getFingerprintData(json: response)
        } catch let fpError {
            var errorString : String = ""
            errorString = "\(AppConstants.ALErrorText.errorTypeGeneric),\(fpError.localizedDescription)"
            fpData[AppConstants.ALDataName.error] = errorString
            Logger.error("Failed to get fingerprint data: \(fpError.localizedDescription)")
        }
        Logger.info("Fingerprint Data: \(fpData)")
        
        var jsonData = Data()
        do {
            try jsonData = JSONSerialization.data(withJSONObject: fpData, options: [])
        } catch let jsonError{
            Logger.error("Exception: \(jsonError.localizedDescription)")
        }
        let jsonEncodedData : String = jsonData.base64EncodedString()
        Logger.info("Encoded Fingerprint Data: \(jsonEncodedData)")
        
        self.webView.evaluateJavaScript("fingerprintData('\(jsonEncodedData)')") { result, error in
            guard error == nil else {
                Logger.error("Error in evaluateJavaScript: \(error!.localizedDescription)")
                return
            }
        }
    }
    
    func resetChallenge() {
        self.webView.evaluateJavaScript(ECConstants.resetMethod) { result, error in
            guard error == nil else {
                Logger.error("Error in evaluateJavScript: \(String(describing: error))")
                return
            }
        }
    }
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == ECConstants.MessageHandler.eventName{
            if let body = message.body as? [String: Any] {
                let name = body[ECConstants.MessageHandler.Keys.name] as! String
                let response = body[ECConstants.MessageHandler.Keys.response] as! [String: Any?]
                
                if(name == ECConstants.CallbackName.onReady) {
                    onReady()
                }
                else if (name == ECConstants.CallbackName.onShow) {
                    onShow()
                }
                else if (name == ECConstants.CallbackName.onShown) {
                    onShown()
                }
                else if (name == ECConstants.CallbackName.onSuppress) {
                    onSupress()
                }
                else if (name == ECConstants.CallbackName.onHide) {
                    onHide()
                }
                else if (name == ECConstants.CallbackName.onReset) {
                    onReset()
                }
                else if (name == ECConstants.CallbackName.onResize) {
                    onResize(response: response)
                }
                else if (name == ECConstants.CallbackName.onCompleted) {
                    onCompleted(response: response)
                }
                else if (name == ECConstants.CallbackName.onError) {
                    onError(response: response)
                }
                else if (name == ECConstants.CallbackName.onFailed) {
                    onFailed(response: response)
                }
                else if (name == ECConstants.CallbackName.onDataRequest) {
                    onDataRequest(response: response as! [String: [String: String]])
                }
            }
        }
    }
}
