//
//  MotionEventListener.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/20/22.
//

import Foundation
import CoreMotion

class MotionData {
    // Acceleration with gravity
    let axg, ayg, azg: Double

    // Acceleration without gravity
    let ax, ay, az: Double

    // Rotation rate
    let rx, ry, rz: Double

    let time: Date
    
    init(axg: Double, ayg: Double, azg: Double, ax: Double, ay: Double, az: Double, rx: Double, ry: Double, rz: Double, time: Date) {
        self.axg = axg
        self.ayg = ayg
        self.azg = azg
        self.ax = ax
        self.ay = ay
        self.az = az
        self.rx = rx
        self.ry = ry
        self.rz = rz
        self.time = time
    }
}

class MotionEventListener: SensorEventListener {
    
    // Constants for value conversion
    let gravityFactor = 9.81
    let radianToDegreeFactor = 180/Double.pi
    
    // Array to collect the values
    var events: [MotionData] = []
    
    // return serialized sensor data
    var sensorData: String {
        return MotionDataSerializer.serialize(events: events)
    }
    
    func reset() {
        events.removeAll()
    }
    
    // Process the sensor data
    func onSensorData(sensorData: CMDeviceMotion, time: Date) {
        let accelWithoutGravity = sensorData.userAcceleration
        let gravity = sensorData.gravity
        let rotationRate = sensorData.rotationRate
        
        let motionData = MotionData(
            axg: (accelWithoutGravity.x + gravity.x) * gravityFactor,
            ayg: (accelWithoutGravity.y + gravity.y) * gravityFactor,
            azg: (accelWithoutGravity.z + gravity.z) * gravityFactor,
            ax: accelWithoutGravity.x * gravityFactor,
            ay: accelWithoutGravity.y * gravityFactor,
            az: accelWithoutGravity.z * gravityFactor,
            rx: rotationRate.x * radianToDegreeFactor,
            ry: rotationRate.y * radianToDegreeFactor,
            rz: rotationRate.z * radianToDegreeFactor,
            time: time)
        
        Logger.debug("MotionEvent received")
        
        events.append(motionData)
    }
}
