import UIKit

@available(iOSApplicationExtension, unavailable)
final class ActionSheetPrimaryView: UIView {
    private let actionsView = ChallengeViewActionsCollectionView()

    var actionTapped: ((ChallengeViewAction) -> Void)? {
        didSet { self.actionsView.actionTapped = self.actionTapped }
    }

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func highlightAction(for sender: UIPanGestureRecognizer) {
        self.actionsView.highlightAction(for: sender)
    }

    func buildView(actions: [ChallengeViewAction], contentView: ChallengeWebView, visualStyle: ChallengeViewVisualStyle) {
        self.configure(visualStyle: visualStyle)

        let effect = visualStyle.backgroundBlurEnabled ? visualStyle.blurEffect : nil
        let backgroundBlur = self.buildBackgroundBlur(effect: effect)
        let labelVibrancy = self.buildLabelVibrancy(effect: effect)
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        let _ = self.buildStackView(views: [labelVibrancy, contentContainer, self.actionsView],
                                            in: backgroundBlur)
        self.buildContentView(contentView, in: contentContainer, visualStyle: visualStyle)
        self.buildActionsView(self.actionsView, actions: actions, visualStyle: visualStyle)

        let _ = visualStyle.contentPadding.left + visualStyle.contentPadding.right
        NSLayoutConstraint.activate([
            backgroundBlur.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundBlur.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundBlur.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundBlur.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    private func configure(visualStyle: ChallengeViewVisualStyle) {
        self.backgroundColor = visualStyle.backgroundColor
        self.layer.cornerRadius = visualStyle.cornerRadius
        self.layer.masksToBounds = true
    }

    private func buildBackgroundBlur(effect: UIVisualEffect?) -> UIVisualEffectView {
        let backgroundBlur = UIVisualEffectView(effect: effect)
        backgroundBlur.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundBlur)

        return backgroundBlur
    }

    private func buildLabelVibrancy(effect: UIBlurEffect?) -> UIVisualEffectView {
        let vibrancy = UIVisualEffectView(effect: effect)
        vibrancy.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *), let effect = effect {
            vibrancy.effect = UIVibrancyEffect(blurEffect: effect, style: .secondaryLabel)
        }

        return vibrancy
    }

    private func buildStackView(views: [UIView], in parent: UIVisualEffectView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center

        parent.contentView.addSubview(stackView)

        // Skip aligning labels, they're aligned separately as they have to account for padding
        for view in views[1...] {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: parent.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])

        return stackView
    }

    private func buildContentView(_ contentView: UIView, in parent: UIView, visualStyle: ChallengeViewVisualStyle) {
        parent.isHidden = contentView.subviews.isEmpty

        parent.addSubview(contentView)

        let topSpace = visualStyle.verticalElementSpacing / 2
        let bottomSpace = visualStyle.contentPadding.bottom

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: visualStyle.margins.left),
            contentView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -visualStyle.margins.right),
            contentView.topAnchor.constraint(equalTo: parent.topAnchor, constant: topSpace),
            contentView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottomSpace),
        ])
    }

    private func buildActionsView(_ actionsView: ChallengeViewActionsCollectionView, actions: [ChallengeViewAction],
                                  visualStyle: ChallengeViewVisualStyle)
    {
        actionsView.actions = actions
        actionsView.visualStyle = visualStyle

        NSLayoutConstraint.activate([
            actionsView.heightAnchor.constraint(equalToConstant: actionsView.displayHeight)
                .prioritized(value: .defaultHigh),
        ])
    }
}
