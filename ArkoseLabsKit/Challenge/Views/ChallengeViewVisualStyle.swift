//
//  ChallengeViewVisualStyle.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

import UIKit

@objc(ChallengeViewVisualStyle)
@available(iOSApplicationExtension, unavailable)
open class ChallengeViewVisualStyle: NSObject {
    @objc
    public var width: CGFloat
    
    @objc
    public var height: CGFloat
    
    @objc
    public var cornerRadius: CGFloat = 5
    
    @objc
    public var contentPadding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    @objc
    public var margins: UIEdgeInsets
    
    @objc
    public var backgroundColor: UIColor?
    
    @objc
    public var actionViewCancelBackgroundColor: UIColor? = {
        guard #available(iOS 13.0, *) else {
            return .white
        }
        
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
            }
            
            return .white
        }
    }()
    
    @objc
    public var verticalElementSpacing: CGFloat = 28
    
    @objc
    public var actionViewSize: CGSize
    
    @objc
    public var actionHighlightColor = UIColor(white: 0.5, alpha: 0.3)
    
    @objc
    public var actionViewSeparatorColor = UIColor(white: 0.5, alpha: 0.5)
    
    @objc
    public var actionViewSeparatorThickness: CGFloat = 1 / UIScreen.main.scale
    
    @objc
    public var textFieldFont = UIFont.systemFont(ofSize: 13)
    
    @objc
    public var textFieldHeight: CGFloat = 25
    
    
    @objc
    public var textFieldBorderColor: UIColor = {
        return UIColor.separator
    }()
    
    @objc
    public var textFieldBackgroundColor: UIColor = {
        return UIColor.systemBackground
    }()
    
    
    @objc
    public var textFieldMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    @objc
    public var normalTextColor: UIColor?
    
    @objc
    public var preferredTextColor: UIColor?
    
    @objc
    public var destructiveTextColor = UIColor.red
    
    @objc
    public var cvPreferredFont = UIFont.boldSystemFont(ofSize: 17)
    
    @objc
    public var cvNormalFont = UIFont.systemFont(ofSize: 17)
    
    /// The font for an action sheet's preferred action
    @objc
    public var sheetPreferredFont = UIFont.boldSystemFont(ofSize: 20)
    
    /// The font for an action sheet's other actions
    @objc
    public var sheetNormalFont = UIFont.systemFont(ofSize: 20)
    
    /// Enables blur effect for an action sheet's background
    @objc
    public var backgroundBlurEnabled: Bool = true
    
    /// The color that dims the surrounding background of the alert to make it stand out more.
    @objc
    public var dimmingColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                return UIColor(white: 0, alpha: traitCollection.userInterfaceStyle == .dark ? 0.48 : 0.2)
            }
        } else {
            return UIColor(white: 0, alpha: 0.2)
        }
    }()
    
    var blurEffect: UIBlurEffect {
        return UIBlurEffect(style: .systemMaterial)
        
    }
    
    private let cvStyle: ChallengeViewControllerStyle
    
    @objc
    public init(cvStyle: ChallengeViewControllerStyle) {
        self.cvStyle = cvStyle
        switch cvStyle {
        case .alert:
            let screenBounds = UIScreen.main.bounds
            
            self.margins = .zero
            self.width = max(screenBounds.width, screenBounds.height)-20
            self.height = max(screenBounds.width, screenBounds.height)-20
            self.actionViewSize = CGSize(width: 90, height: 44)
            
        case .actionSheet:
            self.margins = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
            self.width = 1
            self.height = 1
            self.actionViewSize = CGSize(width: 90, height: 57)
        }
    }
    
    /// The text color for a given action.
    ///
    /// - parameter action: The action that determines the text color.
    ///
    /// - returns: The text color, or nil to use the alert's `tintColor`.
    @objc
    open func textColor(for action: ChallengeViewAction?) -> UIColor? {
        if action?.style == .destructive {
            return self.destructiveTextColor
        } else if action?.style == .preferred {
            return self.preferredTextColor ?? self.normalTextColor
        } else {
            return self.normalTextColor
        }
    }
    
    /// The font for a given action.
    ///
    /// - parameter action: The action for which to return the font.
    ///
    /// - returns: The font.
    @objc
    open func font(for action: ChallengeViewAction?) -> UIFont {
        switch (self.cvStyle, action?.style) {
        case (.alert, let style) where style == .preferred:
            return self.cvPreferredFont
            
        case (.alert, _):
            return self.cvNormalFont
            
        case (.actionSheet, let style) where style == .preferred:
            return self.sheetPreferredFont
            
        case (.actionSheet, _):
            return self.sheetNormalFont
        }
    }
}
