//
//  ChallengeViewControllerRepresentable.swift
//  ArkoseLabsKit
//
//  Created by Avik Niyogi on 17/11/22.
//

import Foundation
import SwiftUI

struct ChallengeViewControllerRepresentable: UIViewControllerRepresentable {
    
    var vc: ChallengeViewController
    
    public func makeUIViewController(context: Context) -> ChallengeViewController {
        return self.vc
    }
    
    public func updateUIViewController(_ uiViewController: ChallengeViewController, context: Context) {
    }

    public init(delegate: ArkoseChallengeDelegate,
                cancelButtonTitle: String? = nil,
                resetButtonTitle: String? = nil) {
        let ecChallengeVC = ChallengeViewController(delegate: delegate,
                                                    preferredStyle: .alert,
                                                    cancelButtonTitle: cancelButtonTitle,
                                                    resetButtonTitle: resetButtonTitle)
        self.vc = ecChallengeVC
    }
    /*
    public init(delegate: ArkoseChallengeDelegate, type: ChallengeViewControllerStyle) {
        let style = ChallengeViewControllerStyle(rawValue: type.rawValue)
        let ecChallengeVC = ChallengeViewController(delegate: delegate, preferredStyle: style!)
        self.vc = ecChallengeVC
    }*/
}
