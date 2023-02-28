//
//  ArkoseConfig.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/21/22.
//

import Foundation

public class ArkoseConfig : NSObject {
    
    let apiKey: String
    let apiBaseUrl: String
    let blob: String?
    let language: String?
    let apiJsFile = "api.js"
    
    let maxMotionEvents: Int
    
    private init(with builder: Builder) {
        self.apiKey = builder.apiKey
        self.apiBaseUrl = builder.apiBaseUrl
        self.blob = builder.blob
        self.language = builder.language
        self.maxMotionEvents = 50
    }
    
    public class Builder  :NSObject {
        
        private(set) var apiKey: String
        private(set) var apiBaseUrl: String
        private(set) var blob: String?
        private(set) var language: String?
        
        public init(withAPIKey apiKey: String) {
            self.apiKey = apiKey
            self.apiBaseUrl = "https://client-api.arkoselabs.com/v2"
        }
        
        public func with(apiKey: String) -> Builder {
            self.apiKey = apiKey
            return self
        }
        
        public func with(apiBaseUrl: String) -> Builder {
            self.apiBaseUrl = apiBaseUrl
            return self
        }
        
        public func with(blob: String) -> Builder {
            self.blob = blob
            return self
        }
        
        public func with(language: String) -> Builder {
            self.language = language
            return self
        }
        
        public func build() -> ArkoseConfig {
            return ArkoseConfig(with: self)
        }
    }
}
