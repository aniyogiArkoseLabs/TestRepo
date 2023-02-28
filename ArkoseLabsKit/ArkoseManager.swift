//
//  ArkoseManager.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 10/17/22.
//

import Foundation
import UIKit
import CoreMotion

//public enum ArkoseChallengeViewStyle: Int {
//    case actionSheet = 1
//    case alert
//}

public final class ArkoseManager : NSObject {
    /// Set the log level for the SDK
    public static var logLevel: LogLevel {
        get { Logger.logLevel }
        set { Logger.logLevel = newValue }
    }
    
    /**
     * Configure the SDK with a specified configuration
     *
     * ### Example
     * ```swift
     *  ArkoseManager.initialize(
     *      with: ArkoseConfig.Builder(withAPIKey: "11111111-1111-1111-1111-111111111111")
     *              .with(apiUrlBase: "https://api.arkoselabs.com/v2")
     *              .with(language: "en")
     *              .build()
     *      )
     * ```
     * 
     */
    public static func initialize(with configuration: ArkoseConfig) {
        ArkoseManagerImpl.shared.initialize(config: configuration)
    }
    
    public static func showEnforcementChallenge(parent: UIViewController,
                                                delegate: ArkoseChallengeDelegate,
                                                cancelButtonTitle: String? = "Cancel",
                                                resetButtonTitle: String? = nil
                                                ) -> Void {
        let viewController = ChallengeViewController(delegate: delegate,
                                                     preferredStyle: .alert,
                                                     cancelButtonTitle: cancelButtonTitle,
                                                     resetButtonTitle: resetButtonTitle)
        parent.present(viewController, animated: true)
    }
    
    /*
    public static func showEnforcementChallenge(parent: UIViewController,
                                                delegate: ArkoseChallengeDelegate
                                                type: ArkoseChallengeViewStyle) -> Void {
        let style = ChallengeViewControllerStyle(rawValue: type.rawValue)
        let viewController = ChallengeViewController(delegate: delegate, preferredStyle: style!)
        parent.present(viewController, animated: true)
    }
    **/
}

//#if ARKOSE_TESTING

public final class ArkoseManagerTest : NSObject {
    
    public final class MotionManagerTest {
        public static func setMax(eventCount: Int) {
            MotionManagerExt.shared.maxEvents = eventCount
        }
        public static var complete = false
        public static var motionSensorData: String {
            return MotionManagerExt.shared.motionSensorData
        }
        public static var orientationSensorData: String {
            return MotionManagerExt.shared.orientationSensorData
        }
        public init(eventHandler: ((_: CMDeviceMotion) -> Void)? = nil) {
        }

    }

    // Subclass to handle sensor data received event
    class MotionManagerExt : MotionManager {
        static let shared = MotionManagerExt()
        var eventHandler: ((_: CMDeviceMotion) -> Void)!
        init(eventHandler: ((_: CMDeviceMotion) -> Void)? = nil) {
            self.eventHandler = eventHandler
            super.init()
        }

        override func onSensorDataReceived(sensorData: CMDeviceMotion) {
            eventHandler?(sensorData)
        }
    }
    
    public static func startMotionManager(eventHandler: ((_: CMDeviceMotion) -> Void)? = nil) {
        
        MotionManagerExt.shared.eventHandler = eventHandler
        _ =  MotionManagerExt.shared.start()
        MotionManagerTest.complete = false
    }
    public static func stopMotionManager() {
        MotionManagerExt.shared.eventHandler = nil
        MotionManagerExt.shared.stop()
        MotionManagerTest.complete = true
    }
}

//#endif
