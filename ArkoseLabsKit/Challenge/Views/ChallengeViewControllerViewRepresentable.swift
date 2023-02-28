//
//  ChallengeViewControllerViewRepresentable.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//
import UIKit
import WebKit

@available(iOSApplicationExtension, unavailable)
protocol ChallengeViewControllerViewRepresentable: UIView {

    var actions: [ChallengeViewAction] { get set }
    var actionTappedHandler: ((ChallengeViewAction) -> Void)? { get set }

    var topView: UIView { get }
    var contentView: ChallengeWebView { get }
    var visualStyle: ChallengeViewVisualStyle! { get set }

    func add(_ behaviors: ChallengeViewBehaviors)
    func prepareLayout()
    func updateLayout(height: CGFloat)
}
