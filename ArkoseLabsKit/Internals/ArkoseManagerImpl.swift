//
//  ArkoseManagerImpl.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/21/22.
//

import Foundation

class ArkoseManagerImpl {
    
    // Singleton instance
    static let shared = ArkoseManagerImpl()
    
    // Config
    private(set) var config: ArkoseConfig?
    
    // MotionManager instance to capture motion data
    let motionManager = MotionManager()
    
    // Properties
    // Sensor data accessors
    var motionSensorData: String {
        return motionManager.motionSensorData
    }
    
    var orientationSensorData: String {
        return motionManager.orientationSensorData
    }
    
    // Private initializer to avoid public initialization
    private init() {
    }
    
    func initialize(config: ArkoseConfig) {
        if self.config != nil {
            return;
        }
        
        self.config = config
        
        // start capturing motion data
        Logger.info("ArkoseManagerImpl.initialize")
        
        Logger.info("Starting MotionManager")
        motionManager.maxEvents = config.maxMotionEvents
        _ = motionManager.start()
    }
    
    func getFingerprintData(json: [String: [String: String]]) throws -> [String: Any] {
        var dataValues : [String: Any] = [:]
        do {
            try dataValues = Fingerprint.getInfo(json: json)
        } catch let fpError {
            var errorString : String = ""
            errorString = "\(AppConstants.ALErrorText.errorTypeGeneric),\(fpError.localizedDescription)"
            dataValues[AppConstants.ALDataName.error] = errorString
            Logger.error("Error getting fingerprint data: \(fpError.localizedDescription)")
        }

        // Stop the motion manager
        self.motionManager.stop()
        
        // get the motion & orientation data
        dataValues[AppConstants.ALDataName.biometricMotion] = self.motionSensorData
        dataValues[AppConstants.ALDataName.biometricOrientation] = self.orientationSensorData
        
        // restart the motion manager
        _ = self.motionManager.start()
        
        return dataValues
    }
}
