//
//  UIView+Accessibility.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
extension UIView {
    func setupAccessibility(using action: ChallengeViewAction) {
        self.accessibilityLabel = action.attributedTitle?.string
        self.accessibilityTraits = .button
        self.accessibilityIdentifier = action.accessibilityIdentifier
        self.isAccessibilityElement = true
    }
}
