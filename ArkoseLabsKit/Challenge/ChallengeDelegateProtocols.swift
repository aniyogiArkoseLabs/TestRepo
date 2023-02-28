//
//  ChallengeDelegateProtocols.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 08/11/22.
//
import Foundation
import UIKit

public protocol ArkoseChallengeDelegate {
    func onReady()
    func onShow()
    func onShown()
    func onSuppress()
    func onHide()
    func onReset()
    func onCompleted(response: [String: Any?])
    func onError(response: [String: Any?])
    func onFailed(response: [String: Any?])
    func onResize(widthValue: CGFloat, heightValue: CGFloat)
}

// Default implementation of the ArkoseChallengeDelegate
public extension ArkoseChallengeDelegate {
    func onReady() {}
    func onShow() {}
    func onShown() {}
    func onSuppress() {}
    func onHide() {}
    func onReset() {}
    func onCompleted(response: [String: Any?]) {}
    func onError(response: [String: Any?]) {}
    func onFailed(response: [String: Any?]) {}
    func onResize(widthValue: CGFloat, heightValue: CGFloat) {}
}

@available(swift, deprecated: 2.0, message: "Use ArkoseChallengeDelegate instead")
public protocol WebEventDelegate {
    func onReady()
    func onShow()
    func onShown()
    func onSuppress()
    func onHide()
    func onReset()
    func onCompleted(response: [String: Any?])
    func onError(response: [String: Any?])
    func onFailed(response: [String: Any?])
    func onResize(widthValue: CGFloat, heightValue: CGFloat)
}

internal protocol ChallengeVCDelegate {
    func shown()
    func dismiss(animated: Bool)
    func resize(widthValue: CGFloat, heightValue: CGFloat)
    
}
