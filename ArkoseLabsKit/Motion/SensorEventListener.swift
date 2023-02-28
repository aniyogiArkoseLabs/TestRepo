//
//  SensorEventListener.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/20/22.
//

import Foundation
import CoreMotion

protocol SensorEventListener {
    var sensorData: String { get }
    func reset()
    func onSensorData(sensorData: CMDeviceMotion, time: Date)
}
