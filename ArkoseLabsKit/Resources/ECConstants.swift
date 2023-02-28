//
//  ECConstants.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 08/11/22.
//

import Foundation
struct ECConstants {
    
    struct CallbackName {
        static let onReady = "onReady"
        static let onShow = "onShow"
        static let onShown = "onShown"
        static let onSuppress = "onSuppress"
        static let onHide = "onHide"
        static let onReset = "onReset"
        static let onCompleted = "onCompleted"
        static let onError = "onError"
        static let onFailed = "onFailed"
        static let onResize = "onResize"
        static let onDataRequest = "onDataRequest"
    }
    
    struct MessageHandler {
        static let eventName = "AL_API_Event"
        struct Keys {
            static let name = "name"
            static let response = "response"
        }
    }
    
    static let resetMethod = "resetSession()"
}
