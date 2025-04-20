import Foundation

/// Simple logging utility for OpenAISwift
@available(iOS 14.0, macOS 11.0, *)
internal struct Logger {
    /// Log levels for controlling verbosity
    enum Level: Int, Comparable {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        case none = 4
        
        static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    /// The current log level
    static var logLevel: Level = .warning
    
    /// Logs a debug message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func debug(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message(), file: file, function: function, line: line)
    }
    
    /// Logs an info message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func info(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message(), file: file, function: function, line: line)
    }
    
    /// Logs a warning message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func warning(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warning, message: message(), file: file, function: function, line: line)
    }
    
    /// Logs an error message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func error(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message(), file: file, function: function, line: line)
    }
    
    private static func log(level: Level, message: String, file: String, function: String, line: Int) {
        guard level >= logLevel else { return }
        
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let prefix: String
        
        switch level {
        case .debug: prefix = "[DEBUG]"
        case .info: prefix = "[INFO]"
        case .warning: prefix = "[WARNING]"
        case .error: prefix = "[ERROR]"
        case .none: return
        }
        
        print("\(prefix) \(fileName):\(line) - \(message)")
    }
}