//
//  MotionDataSerializer.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 11/20/22.
//

import Foundation

class MotionDataSerializer {
    
    let DATA_FORMAT = "%ld,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f;"
    
    func serializeImpl(events: [MotionData]) -> String {
        
        // If no events are present, return an empty string
        if events.isEmpty {
            return ""
        }
        
        // Set the start time to the first events time
        let startTime = events[0].time

        var serializedData: String = ""
                
        let startTimeSeconds = Int(startTime.timeIntervalSince1970)
        serializedData = String(format: "%d;%ld;", 1, startTimeSeconds)
        
        // Iterate through all the events in the array
        for item in events {
            // Calculate the time difference from the start
            let time = Int(item.time.timeIntervalSince(startTime) * 1000)
            
            // Fromat the data
            let str: String = String(format: DATA_FORMAT,
                                     time,
                                     item.ax, item.ay, item.az,
                                     item.axg, item.ayg, item.azg,
                                     item.rx, item.ry, item.rz
                                    )
            serializedData += str
        }
        
        return serializedData
    }
    
    static func serialize(events: [MotionData]) -> String {
        let thiz = MotionDataSerializer()
        return thiz.serializeImpl(events: events)
    }
}
