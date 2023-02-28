//
//  Bundle+Convenience.swift
//  ArkoseiOSEC
//
//  Created by Avik Niyogi on 30/10/22.
//

import Foundation

extension Bundle {
    #if SWIFT_PACKAGE
    static var resourceBundle: Bundle = .module
    #else
    static var resourceBundle: Bundle {
        let sourceBundle = Bundle(for: ChallengeViewController.self)
        let bundleURL = sourceBundle.url(forResource: "ArkoseiOSEC", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init(url:)) ?? sourceBundle
    }
    #endif
}

