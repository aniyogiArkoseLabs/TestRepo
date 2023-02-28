//
//  ChallengeViewController.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 12/10/22.
//

import UIKit
import WebKit

fileprivate let sizeBuffer : CGFloat = 15

/// The alert controller's style
@objc(ChallengeViewControllerStyle)
public enum ChallengeViewControllerStyle: Int {
    // An action sheet style alert that slides in from the bottom and presents the user with a list of
    // possible actions to perform. Does not show as expected on iPad.
    case actionSheet = 1
    // The standard alert style that asks the user for information or confirmation.
    case alert
}

/// The layout of the alert's actions. Only applies to AlertControllerStyle.alert, not .actionSheet.
@objc(ChallengeViewActionLayout)
public enum ChallengeViewActionLayout: Int {
    /// If the alert has 2 actions, display them horizontally. Otherwise, display them vertically.
    case automatic
    /// Display the actions vertically.
    case vertical
    /// Display the actions horizontally.
    case horizontal
}

@objc(ChallengeViewController)
@available(iOSApplicationExtension, unavailable)
final class ChallengeViewController: UIViewController, ChallengeVCDelegate {
    func dismiss(animated: Bool) {
        self.dismiss()
    }
    
    func shown() {
        self.toggleSpinner(isPresent: false)
        self.configureAlertView()
    }
    func resize(widthValue: CGFloat, heightValue: CGFloat) {
        
        // save the value, so we can use in viewWillTransition
        self.ecWidth = widthValue
        self.ecHeight = heightValue
        
        if (self.preferredStyle == .alert) {
            self.visualStyle.width = widthValue + self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right
            self.visualStyle.height = heightValue + self.visualStyle.contentPadding.top + self.visualStyle.contentPadding.bottom + self.visualStyle.actionViewSize.height
        }
        else {
            self.visualStyle.width = widthValue + self.visualStyle.margins.left + self.visualStyle.margins.right
            self.visualStyle.height = heightValue + self.visualStyle.margins.top + self.visualStyle.actionViewSize.height * 2 + 8
        }
        
        var screenBounds = UIScreen.main.bounds
        screenBounds = screenBounds.insetBy(dx: 15, dy: 15)
        if self.visualStyle.width > screenBounds.width {
            self.visualStyle.width = screenBounds.width
        }
        if self.visualStyle.height > screenBounds.height {
            self.visualStyle.height = screenBounds.height
        }

        updateConstraints()
        self.challengeView.updateLayout(height: heightValue)
        
    }
    func updateConstraints() {
        
        if ((self.widthAnchorConstraint) != nil) {
            self.challengeView.removeConstraint(self.widthAnchorConstraint!)
        }
        self.widthAnchorConstraint = self.challengeView.widthAnchor.constraint(equalToConstant: self.visualStyle.width)
        self.widthAnchorConstraint?.isActive = true
        
        if ((self.heightAnchorConstraint) != nil) {
            self.challengeView.removeConstraint(self.heightAnchorConstraint!)
        }
        self.heightAnchorConstraint = self.challengeView.heightAnchor.constraint(equalToConstant: self.visualStyle.height)
        self.heightAnchorConstraint?.isActive = true
        
        
    }
    
    private var ecWidth: CGFloat = 0
    private var ecHeight: CGFloat = 0
    private var widthAnchorConstraint: NSLayoutConstraint?
    private var heightAnchorConstraint: NSLayoutConstraint?
    private var verticalCenterConstraint: NSLayoutConstraint?

    var didRotate: (Notification) -> Void = { notification in
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                print("landscape")
            case .portrait, .portraitUpsideDown:
                print("Portrait")
            default:
                print("other (such as face up & down)")
            }
        }
    
    @objc
    public var contentView: UIView {
        return self.challengeView.contentView
    }
    
    /// The alert's actions (buttons).
    @objc
    private var actions = [ChallengeViewAction]() {
        didSet { self.challengeView.actions = self.actions }
    }
    
    /// The alert's preferred action, if one is set. Setting this value to an action that wasn't already added
    /// to the array will add it and override its style to `.preferred`. Setting this value to `nil` will
    /// remove the preferred style from all actions.
    @objc
    public var preferredAction: ChallengeViewAction? {
        get {
            if self.preferredStyle == .actionSheet {
                return nil
            }
            
            let index = self.actions.firstIndex { $0.style == .preferred }
            return index != nil ? self.actions[index!] : nil
        }
        set {
            if let action = newValue {
                action.style = .preferred
                
                if self.actions.firstIndex(where: { $0 == newValue }) == nil {
                    self.actions.append(action)
                }
            } else {
                self.actions.forEach { $0.style = .normal }
            }
        }
    }
    
    /// The layout of the actions in the alert, or `.automatic` for action sheets.
    @objc
    public var actionLayout: ChallengeViewActionLayout {
        get { return (self.challengeView as? ChallengeView)?.actionLayout ?? .automatic }
        set { (self.challengeView as? ChallengeView)?.actionLayout = newValue }
    }
    
    /// The text fields that are added to the alert. Does nothing when used with an action sheet.
    @objc
    private(set) public var textFields: [UITextField]?
    
    /// The alert's custom behaviors. See `AlertBehaviors` for possible options.
    public lazy var behaviors: ChallengeViewBehaviors = ChallengeViewBehaviors.defaultBehaviors(forStyle: self.preferredStyle)
    
    @objc
    public var resetHandler: ((ChallengeViewAction?) -> Bool)?
    /// A closure that, when set, returns whether the alert or action sheet should dismiss after the user taps
    /// on an action. If it returns false, the AlertAction handler will not be executed.
    @objc
    public var shouldDismissHandler: ((ChallengeViewAction?) -> Bool)?
    
    /// A closure called before the alert is dismissed but only if done by own method and not manually
    @objc
    public var willDismissHandler: (() -> Void)?
    
    /// A closure called when the alert is dismissed after an outside tap (when `dismissOnOutsideTap` behavior
    /// is enabled)
    @objc
    public var outsideTapHandler: (() -> Void)?
    
    /// The visual style that applies to the alert or action sheet.
    @objc
    public lazy var visualStyle: ChallengeViewVisualStyle = ChallengeViewVisualStyle(cvStyle: self.preferredStyle)
    
    /// The alert's presentation style.
    @objc
    public let preferredStyle: ChallengeViewControllerStyle
    
    private let challengeView: UIView & ChallengeViewControllerViewRepresentable
    private var activityView : UIActivityIndicatorView
    private lazy var transitionDelegate = Transition(cvStyle: self.preferredStyle,
                                                     dimmingViewColor: self.visualStyle.dimmingColor)
    
    // MARK: - Initialization

    
    public init(delegate: ArkoseChallengeDelegate,
                preferredStyle: ChallengeViewControllerStyle = .alert,
                cancelButtonTitle: String?,
                resetButtonTitle: String?) {
        switch preferredStyle {
        case .alert:
            self.challengeView = ChallengeView(delegate: delegate)
            
        case .actionSheet:
            self.challengeView = ChallengeSheetView(delegate: delegate)
        }
        
        self.preferredStyle = preferredStyle
        self.activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        super.init(nibName: nil, bundle: nil)
        self.commonInit(cancelButtonTitle: cancelButtonTitle, resetButtonTitle: resetButtonTitle)
    }
    
    private func setChallengeVCDelegate(delegate: ChallengeVCDelegate) {
        self.challengeView.contentView.setChallengeVCDelegate(delegate: delegate)
    }
    
    @available(*, unavailable, message: "Please use one of the provided AlertController initializers")
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func commonInit(cancelButtonTitle: String?, resetButtonTitle: String?) {
        self.setChallengeVCDelegate(delegate: self)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitionDelegate
        if resetButtonTitle != nil {
            self.addAction(ChallengeViewAction(title: resetButtonTitle, style: .normal))
            self.resetHandler = { $0?.title == resetButtonTitle }
        }
        
        if cancelButtonTitle != nil {
            self.addAction(ChallengeViewAction(title: cancelButtonTitle, style: .preferred))
            self.shouldDismissHandler = { $0?.title == cancelButtonTitle}
        }
        
        // If no buttons are added, set the actionViewSize.height = 0, so layout can be proper
        if resetButtonTitle == nil && cancelButtonTitle == nil {
            self.visualStyle.actionViewSize.height = 0
        }
        
        if self.preferredStyle == .alert {
            let command = UIKeyCommand(input: "\r", modifierFlags: [],
                                       action: #selector(self.handleHardwareReturnKey))
            self.addKeyCommand(command)
        }
    }
    
    // MARK: - Public
    
    
    /// Presents the alert.
    ///
    /// - parameter animated:   Whether to present the alert animated.
    /// - parameter completion: An optional closure that's called when the presentation finishes.
    @objc(presentAnimated:completion:)
    public func present(animated: Bool = true, completion: (() -> Void)? = nil) {
        let topViewController = UIViewController.topViewController()
        topViewController?.present(self, animated: animated, completion: completion)
    }
    
    /// Dismisses the alert.
    ///
    /// - parameter animated:   Whether to dismiss the alert animated.
    /// - parameter completion: An optional closure that's called when the dismissal finishes.
    @objc(dismissViewControllerAnimated:completion:)
    public override func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard presentedViewController == nil else {
            super.dismiss(animated: animated, completion: completion)
            return
        }
        
        self.willDismissHandler?()
        self.presentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Override
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleSpinner(isPresent: true)
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textFields?.first?.resignFirstResponder()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Update the view size
        self.resize(widthValue: self.ecWidth, heightValue: self.ecHeight)
    }
    
    public override func becomeFirstResponder() -> Bool {
        if self.behaviors.contains(.automaticallyFocusTextField) {
            return self.textFields?.first?.becomeFirstResponder() ?? super.becomeFirstResponder()
        }
        
        return super.becomeFirstResponder()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.presentingViewController?.preferredStatusBarStyle ?? .default
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.presentingViewController?.supportedInterfaceOrientations
        ?? super.supportedInterfaceOrientations
    }
    
    // MARK: - Private
    @objc
    private func addAction(_ action: ChallengeViewAction) {
        self.actions.append(action)
    }
    
    @objc
    private func handleHardwareReturnKey() {
        if let preferredAction = self.preferredAction {
            self.challengeView.actionTappedHandler?(preferredAction)
        }
    }
    
    private func configureAlertView() {
        self.challengeView.translatesAutoresizingMaskIntoConstraints = false
        self.challengeView.visualStyle = self.visualStyle
        self.challengeView.add(self.behaviors)
        
        self.addChromeTapHandlerIfNecessary()
        
        self.view.addSubview(self.challengeView)
        self.createViewConstraints()
        
        self.challengeView.prepareLayout()
        self.challengeView.actionTappedHandler = { [weak self] action in
            if self?.shouldDismissHandler?(action) != false {
                self?.dismiss(animated: true) {
                    action.handler?(action)
                }
            }
            if self?.resetHandler?(action) != false {
                self?.challengeView.contentView.resetChallenge()
            }
        }
        
        self.challengeView.layoutIfNeeded()
    }
    
    private func toggleSpinner(isPresent: Bool) {
        if isPresent {
            activityView.center = self.view.center
            activityView.color = .black
            activityView.alpha = 1.0
            activityView.startAnimating()
            
            self.view.addSubview(activityView)
        }
        else {
            activityView.removeFromSuperview()
        }
        
    }
    
    private func createViewConstraints() {
        let margins = self.visualStyle.margins
        
        self.ecWidth = self.visualStyle.width
        self.ecHeight = self.visualStyle.height
    
        switch self.preferredStyle {
        case .actionSheet:
            let bounds = self.presentingViewController?.view.bounds ?? self.view.bounds
            let width = min(bounds.width, bounds.height) - margins.left - margins.right
            self.widthAnchorConstraint = self.challengeView.widthAnchor.constraint(equalToConstant: width * self.visualStyle.width)
            self.widthAnchorConstraint?.isActive = true
            NSLayoutConstraint.activate([
                
                self.challengeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.challengeView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                           constant: margins.bottom),
                self.challengeView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor,
                                                           constant: -margins.top)
            ])
            
        case .alert:
            self.widthAnchorConstraint = self.challengeView.widthAnchor.constraint(equalToConstant: self.visualStyle.width)
            self.widthAnchorConstraint?.isActive = true
            self.verticalCenterConstraint = self.challengeView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            self.heightAnchorConstraint = self.challengeView.heightAnchor.constraint(equalToConstant: self.visualStyle.height)
            self.heightAnchorConstraint?.isActive = true
            
            self.verticalCenterConstraint!.isActive = true
            self.challengeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            let priority = UILayoutPriority(rawValue: 500)
            self.challengeView.setContentCompressionResistancePriority(priority, for: .vertical)
        }
    }
    
    
    private func addChromeTapHandlerIfNecessary() {
        if !self.behaviors.contains(.dismissOnOutsideTap) {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chromeTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func chromeTapped(_ sender: UITapGestureRecognizer) {
        if !self.challengeView.frame.contains(sender.location(in: self.view)) {
            self.dismiss() {
                self.outsideTapHandler?()
            }
        }
    }
}
