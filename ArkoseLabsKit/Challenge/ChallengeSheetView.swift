//
//  ChallengeSheetView.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
final class ChallengeSheetView: UIView, ChallengeViewControllerViewRepresentable {
    private let primaryView = ActionSheetPrimaryView()
    private let cancelView = ActionSheetCancelActionView()

    var contentView : ChallengeWebView
    var topView: UIView { self }
    var actions: [ChallengeViewAction] = []
    var visualStyle: ChallengeViewVisualStyle!

    var actionTappedHandler: ((ChallengeViewAction) -> Void)? {
        didSet {
            self.primaryView.actionTapped = self.actionTappedHandler
            self.cancelView.cancelTapHandler = self.actionTappedHandler
        }
    }
    init(delegate: ArkoseChallengeDelegate) {
        self.contentView = ChallengeWebView(delegate: delegate, frame: .zero)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.primaryView)
        self.addSubview(self.cancelView)
        if let cancelAction = self.assignCancelAction() {
            self.cancelView.buildView(cancelAction: cancelAction, visualStyle: self.visualStyle)
        }
        self.primaryView.buildView(actions: self.actions, contentView: self.contentView,
                                   visualStyle: self.visualStyle)
        createConstraints()
    }
    func createConstraints() {
        NSLayoutConstraint.activate([
            self.primaryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.primaryView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.primaryView.topAnchor.constraint(equalTo: self.topAnchor),

            self.primaryView.bottomAnchor.constraint(equalTo: self.cancelView.topAnchor, constant: -8),

            self.cancelView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cancelView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cancelView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    func updateLayout(height: CGFloat) {
        self.contentView.updateLayout(height: height)
        createConstraints()
    }

    func add(_ behaviors: ChallengeViewBehaviors) {
        if !behaviors.contains(.dragTap) {
            return
        }

        let panGesture = UIPanGestureRecognizer()
        panGesture.cancelsTouchesInView = false
        panGesture.addTarget(self.primaryView, action: #selector(self.primaryView.highlightAction(for:)))
        panGesture.addTarget(self.cancelView, action: #selector(self.cancelView.highlightAction(for:)))
        self.addGestureRecognizer(panGesture)
    }

    // MARK: - Private

    private func assignCancelAction() -> ChallengeViewAction? {
        if actions.isEmpty {
            return nil
        }
        
        if let cancelActionIndex = self.actions.firstIndex(where: { $0.style == .preferred }) {
            let cancelAction = self.actions[cancelActionIndex]
            self.actions.remove(at: cancelActionIndex)
            return cancelAction
        } else {
            let cancelAction = self.actions.first
            self.actions.removeFirst()
            return cancelAction
        }
    }
}

