//
//  Logger.swift
//  ArkoseLabsKit
//
//  Created by Prabha Kaliyamoorthy on 10/14/22.
//

import Foundation

/// Enumeration of different log levels
public enum LogLevel: Int, CustomStringConvertible {

    case debug, info, warn, error

    public var description: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warn: return "WARN"
        case .error: return "ERROR"
        }
    }
}

/// A class for writing string messages to the unified logging system
///  Generally, you should use debug(), info(), warn() and error() methods to write logs
class Logger {
    
    /// Framework name used in the log message
    internal static let frameworkName = "ArkoseLabsKit"
    
    /// Default log level based on the build type
    private static var defaultLogLevel: LogLevel {
        #if DEBUG
        return .debug
        #else
        return .info
        #endif
    }
    
    /// Controls the logs send to the logging system. Any log messages less than the log level are not logged
    private static var _logLevel: LogLevel = defaultLogLevel
    
    /// Log level property wrapper to control the setter
    static var logLevel: LogLevel {
        get { return _logLevel }
        set {
            // Don't allow setting debug level in release build
            // Use the defaultLogLevel to find out the min level for a build type
            if newValue.rawValue < defaultLogLevel.rawValue {
                warn("\(newValue) log level is not allowed")
            } else {
                _logLevel = newValue
            }
        }
    }

    /// Writes a debug message to the log.
    static func debug(_ message: @autoclosure () -> CustomStringConvertible,
                      fileId: String? = #fileID,
                      functionName: String? = #function,
                      line: UInt = #line) {
        #if DEBUG
        // Build file context info
        let fileName = (fileId! as NSString)
            .lastPathComponent
            .replacingOccurrences(of: ".swift", with: "")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        let fileContext = "\(fileName).\(functionName ?? ""):\(line)"
        let debugMessage = "\(fileContext): \(message().description)"
        log(level: .debug, message: debugMessage)
        #endif
    }
  
    /// Writes an informative message to the log.
    static func info(_ message: @autoclosure () -> CustomStringConvertible) {
        log(level: .info, message: message().description)
    }

    /// Writes information about a warning to the log.
    static func warn(_ message: @autoclosure () -> CustomStringConvertible) {
        log(level: .warn, message: message().description)
    }

    /// Writes information about an error to the log.
    static func error(_ message: @autoclosure () -> CustomStringConvertible) {
        log(level: .error, message: message().description)
    }
}

/// Logger extension to send the log message to the default log handler
private extension Logger {
    
    static let NSLogMax = 1023
    
    /// Writes a log message to underlying logging system
    static func log(level: LogLevel,
                    message: @autoclosure () -> String) {
        guard self.logLevel.rawValue <= level.rawValue else { return }
        var loggerMessage : String = "[\(frameworkName)] - \(level.description) \(message())"
        while( loggerMessage.count > NSLogMax) {
            var range = loggerMessage.startIndex ..< loggerMessage.index(loggerMessage.startIndex, offsetBy: NSLogMax)
            NSLog("%@",String(loggerMessage[range]))
            range = loggerMessage.index(loggerMessage.startIndex, offsetBy: NSLogMax) ..< loggerMessage.endIndex
            loggerMessage = String(loggerMessage[range])
        }
        NSLog("%@",loggerMessage)
    }
}
