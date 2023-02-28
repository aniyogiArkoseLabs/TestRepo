//
//  ALVersionView.swift
//  ArkoseLabsKit
//
//  Created by ArkoseLabs on 07/04/22.
//

import SwiftUI

public struct ALVersionView: UIViewRepresentable {
    
    public class Coordinator : NSObject {
        public var parentView: ALVersionView
        public init(_ parent: ALVersionView) {
            self.parentView = parent
        }
    }
    public var versionAndBuildNumber: String
    
    public init() {
        let version = Bundle(identifier: "ArkoseLabs.ArkoseLabsKit")?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle(identifier: "ArkoseLabs.ArkoseLabsKit")?.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        versionAndBuildNumber = "Mobile SDK \(version)  Build:(\(build))"
    }
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UILabel {
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        versionLabel.text = versionAndBuildNumber
        versionLabel.font = versionLabel.font.withSize(10)
        versionLabel.sizeToFit()
        versionLabel.textAlignment = NSTextAlignment.center
        return versionLabel
    }
    public func updateUIView(_ uiView: UILabel, context: Context) {
    }
    public static func dismantleUIView(_ uiView: UILabel, coordinator: Coordinator) {
        uiView.removeFromSuperview()
    }
}
