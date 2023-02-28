//
//  MotionManager.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/19/22.
//

import Foundation
import CoreMotion
import UIKit

/**
 Sensor Running state
 */
private enum SensorState {
    case STOPPED
    case RUNNING
    case PAUSED
}

class MotionManager {
    // Max number events to be captured
    public var maxEvents: Int
    // Event counter to keep track of the collected events
    private var eventCounter = 0
    
    // System sensor and the state
    private var motionManager: CMMotionManager
    private var state: SensorState = .STOPPED
    
    // Sensor listeners
    private var motionEventListener: SensorEventListener
    private var orientationEventListener: SensorEventListener
    
    // Sensor data accessors
    var motionSensorData: String {
        return motionEventListener.sensorData
    }
    
    var orientationSensorData: String {
        return orientationEventListener.sensorData
    }
    
    init() {
        maxEvents = 50;
        motionManager = CMMotionManager();
        motionManager.deviceMotionUpdateInterval = 0.1
        motionEventListener = MotionEventListener()
        orientationEventListener = OrientationEventListener()
    }
    
    func start() -> Bool {
        Logger.info("MotionManager.start")
        if state != .STOPPED {
            return false
        }
        
        // Setup notification listeneres for App events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationWillResignActive(notification:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        // reset all listeners
        motionEventListener.reset()
        orientationEventListener.reset()
        reset()
        
        // Start the sensor updates
        startUpdates()
        state = .RUNNING
        
        return true
    }
    
    func stop() {
        Logger.info("MotionManager.stop")
        if state == .STOPPED {
            return
        }

        stopUpdates()
        
        // Setup notification listeneres for App events
        NotificationCenter.default.removeObserver(self,
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.removeObserver(self,
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        state = .STOPPED
    }
    
    func pause() {
        Logger.info("MotionManager.pause")
        if state != .RUNNING {
            return;
        }
        stopUpdates()
        state = .PAUSED;
    }
    
    func resume() {
        Logger.info("MotionManager.resume")
        if state != .PAUSED {
            return;
        }
        startUpdates()
        state = .RUNNING;
    }
    
    @objc private func applicationDidBecomeActive(notification: Notification) {
        resume()
    }

    @objc private func applicationWillResignActive(notification: Notification) {
        pause()
    }
    
    private func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            // Get the current time
            let timeNow = Date()
            
            // Process the data
            if self.eventCounter < self.maxEvents {
                self.eventCounter += 1
                self.motionEventListener.onSensorData(sensorData: data, time: timeNow)
                self.orientationEventListener.onSensorData(sensorData: data, time: timeNow)
            }
            
            // Custom processing if any in the sub classes
            self.onSensorDataReceived(sensorData: data)
        }
    }
    
    private func stopUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func reset() {
        eventCounter = 0
    }
    
    func onSensorDataReceived(sensorData: CMDeviceMotion) {
        
    }
}
