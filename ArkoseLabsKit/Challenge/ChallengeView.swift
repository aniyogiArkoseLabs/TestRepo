//
//  ChallengeView.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 12/10/22.
//
import UIKit

@available(iOSApplicationExtension, unavailable)
final class ChallengeView: UIView, ChallengeViewControllerViewRepresentable {
    private let scrollView = UIScrollView()
    private var actionsCollectionView = ChallengeViewActionsCollectionView()
    
    var contentView : ChallengeWebView
    var actions: [ChallengeViewAction] = []
    var actionLayout = ChallengeViewActionLayout.automatic
    
    var textFieldsViewController: TextFieldsViewController? {
        didSet { self.textFieldsViewController?.visualStyle = self.visualStyle }
    }
    
    var visualStyle: ChallengeViewVisualStyle! {
        didSet { self.textFieldsViewController?.visualStyle = self.visualStyle }
    }
    
    var actionTappedHandler: ((ChallengeViewAction) -> Void)? {
        get { return self.actionsCollectionView.actionTapped }
        set { self.actionsCollectionView.actionTapped = newValue }
    }
    
    var topView: UIView { self.scrollView }
    
    override var intrinsicContentSize: CGSize {
        let totalHeight = self.contentHeight + self.actionsCollectionView.displayHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
    
    private var elements: [UIView] {
        let possibleElements: [UIView?] = [
            self.textFieldsViewController?.view,
            self.contentView.subviews.count > 0 ? self.contentView : nil,
        ]
        
        return possibleElements.compactMap { $0 }
    }
    
    private var contentHeight: CGFloat {
        guard let lastElement = self.elements.last else {
            return 0
        }
        
        lastElement.layoutIfNeeded()
        return lastElement.frame.maxY
    }
    
    init(delegate: ArkoseChallengeDelegate) {
        self.contentView = ChallengeWebView(delegate: delegate, frame: .zero)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        self.actionsCollectionView.actions = self.actions
        self.actionsCollectionView.visualStyle = self.visualStyle
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.scrollView)
        
        self.updateCollectionViewScrollDirection()
        
        self.createBackground()
        self.createUI()
        self.createContentConstraints()
        self.updateUI()
    }
    
    func updateLayout(height: CGFloat) {
        self.contentView.updateLayout(height: height)
        self.createContentConstraints()
        self.actionsCollectionView.reloadData()
    }
    
    func add(_ behaviors: ChallengeViewBehaviors) {
        if !behaviors.contains(.dragTap) {
            return
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.highlightAction(for:)))
        self.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Private methods
    
    private func createBackground() {
        if let color = self.visualStyle.backgroundColor {
            self.backgroundColor = color
            return
        }
        
        var style: UIBlurEffect.Style
        style = .systemMaterial
        
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.insertSubview(backgroundView, belowSubview: self.scrollView)
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func createUI() {
        for element in self.elements {
            element.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(element)
        }
        
        self.actionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.actionsCollectionView)
    }
    
    private func updateCollectionViewScrollDirection() {
        let layout = self.actionsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        if self.actionLayout == .horizontal || (self.actions.count == 2 && self.actionLayout == .automatic) {
            layout?.scrollDirection = .horizontal
        } else {
            layout?.scrollDirection = .vertical
        }
    }
    
    private func updateUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.visualStyle.cornerRadius
        self.textFieldsViewController?.visualStyle = self.visualStyle
    }
    
    @objc
    private func highlightAction(for sender: UIPanGestureRecognizer) {
        self.actionsCollectionView.highlightAction(for: sender)
    }
    
    // MARK: - Constraints
    
    private func createContentConstraints() {
        self.createCustomContentViewConstraints()
        self.createCollectionViewConstraints()
        self.createScrollViewConstraints()
    }
    
    private func createCustomContentViewConstraints() {
        if !self.elements.contains(self.contentView) {
            return
        }
        
        let widthOffset = self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right
        NSLayoutConstraint.activate([
            self.contentView.firstBaselineAnchor.constraint(equalTo: self.topAnchor, constant: self.visualStyle.contentPadding.top),
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -widthOffset),
        ])
        
        self.pinBottomOfScrollView(to: self.contentView, withPriority: .defaultLow + 3.0)
    }
    
    private func createCollectionViewConstraints() {
        let height = self.actionsCollectionView.displayHeight
        let heightConstraint = self.actionsCollectionView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightConstraint,
            self.actionsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.actionsCollectionView.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.actionsCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.actionsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func createScrollViewConstraints() {
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.visualStyle.contentPadding.top).isActive = true
        self.scrollView.layoutIfNeeded()
        
        let height = self.scrollView.contentSize.height
        let heightConstraint = self.scrollView.heightAnchor.constraint(equalToConstant: height-self.visualStyle.contentPadding.top)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
    
    private func pinBottomOfScrollView(to view: UIView, withPriority priority: UILayoutPriority) {
        let bottom = view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        bottom.constant = -self.visualStyle.contentPadding.bottom
        bottom.priority = priority
        bottom.isActive = true
    }
}

private extension UILayoutPriority {
    static func + (lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue + rhs)
    }
}
