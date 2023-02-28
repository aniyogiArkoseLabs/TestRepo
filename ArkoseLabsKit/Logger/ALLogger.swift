//
//  ALLogger.swift
//  ArkoseLabsKit
//
//  Created by Avik Niyogi on 01/10/21.
//

import Foundation

class ALLogger: TextOutputStream {

    func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        print(log)
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            let dateString = "\n\(NSDate.now)"
            handle.write(dateString.data(using: .utf8)!)
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
    func clearLog() {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        do{
            try fm.removeItem(at: log)
        } catch {
            ALLogger.logger.write("LOG: Delete Error")
        }
        
    }
    static var logger: ALLogger = ALLogger()
    private init() {}
}
