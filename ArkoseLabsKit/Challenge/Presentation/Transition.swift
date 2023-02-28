//
//  Transition.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

import UIKit

class Transition: NSObject, UIViewControllerTransitioningDelegate {

    private let cvStyle: ChallengeViewControllerStyle
    private let dimmingViewColor: UIColor

    init(cvStyle: ChallengeViewControllerStyle, dimmingViewColor: UIColor) {
        self.cvStyle = cvStyle
        self.dimmingViewColor = dimmingViewColor
    }

    func presentationController(forPresented presented: UIViewController,
        presenting: UIViewController?, source: UIViewController)
        -> UIPresentationController?
    {
        return PresentationController(presentedViewController: presented,
                                      presenting: presenting,
                                      dimmingViewColor: dimmingViewColor)
    }

    func animationController(forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        if self.cvStyle == .actionSheet {
            return nil
        }

        return AnimationController(presentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.cvStyle == .alert ? AnimationController(presentation: false) : nil
    }
}

