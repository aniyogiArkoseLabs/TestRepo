//
//  OrientationEventListener.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/20/22.
//

import Foundation
import CoreMotion

class OrientationData {
    let pitch, roll, yaw: Double
    
    let time: Date
    
    init(pitch: Double, roll: Double, yaw: Double, time: Date) {
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
        self.time = time
    }
}

class OrientationEventListener: SensorEventListener {
    
    // Constants for value conversipn
    let radianToDegreeFactor = 180/Double.pi
    
    // Array to collect the values
    var events: [OrientationData] = []
    
    // return serialized sensor data
    var sensorData: String {
        return OrientationDataSerializer.serialize(events: events)
    }
    
    func reset() {
        events.removeAll()
    }
    
    // Process the sensor data
    func onSensorData(sensorData: CMDeviceMotion, time: Date) {
        let attitude = sensorData.attitude
        
        let oriData = OrientationData(
            pitch: attitude.pitch * radianToDegreeFactor,
            roll: attitude.roll * radianToDegreeFactor,
            yaw: attitude.yaw * radianToDegreeFactor,
            time: time)
        
        Logger.debug("OrientationEvent received")
        
        events.append(oriData)
    }
}
