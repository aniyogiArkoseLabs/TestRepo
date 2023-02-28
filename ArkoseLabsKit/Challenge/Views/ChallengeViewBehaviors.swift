//
//  AlertBehaviors.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

struct ChallengeViewBehaviors: OptionSet {
    /// When applied, the user can dismiss the alert or action sheet by tapping outside of it. Enabled for
    /// action sheets by default.
    public static let dismissOnOutsideTap = ChallengeViewBehaviors(rawValue: 1)

    /// Applies the "drag tap" behavior, meaning when the user taps on an action and then drags their finger
    /// to another action the new action will be selected.
    public static let dragTap = ChallengeViewBehaviors(rawValue: 1 << 1)

    /// Automatically focuses the first text field in an alert. This doesn't work for text fields added to an
    /// alert's content view.
    public static let automaticallyFocusTextField = ChallengeViewBehaviors(rawValue: 1 << 3)

    static func defaultBehaviors(forStyle style: ChallengeViewControllerStyle) -> ChallengeViewBehaviors {
        let behaviors: ChallengeViewBehaviors = [.dragTap]

        switch style {
            case .actionSheet:
                return behaviors.union(.dismissOnOutsideTap)

            case .alert:
                return behaviors.union(.automaticallyFocusTextField)
        }
    }

    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
}
