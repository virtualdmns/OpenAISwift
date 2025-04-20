import Foundation

/// Represents errors that can occur when interacting with the OpenAI API
@available(iOS 14.0, macOS 11.0, *)
public enum OpenAIError: Error, LocalizedError {
    /// The API returned an error response
    case apiError(APIErrorResponse)
    
    /// An error occurred during the network request
    case networkError(Error)
    
    /// The response couldn't be decoded
    case decodingError(Error)
    
    /// The request couldn't be encoded
    case encodingError(Error)
    
    /// Invalid request parameters
    case invalidRequest(String)
    
    /// The API key is missing or invalid
    case authenticationError
    
    /// Unknown error occurred
    case unknown(String?)
    
    public var errorDescription: String? {
        switch self {
        case .apiError(let response):
            return "API Error: \(response.error.message)"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding Error: \(error.localizedDescription)"
        case .invalidRequest(let message):
            return "Invalid Request: \(message)"
        case .authenticationError:
            return "Authentication Error: Invalid or missing API key"
        case .unknown(let message):
            return "Unknown Error: \(message ?? "No details available")"
        }
    }
}

/// Represents the error response structure from the OpenAI API
@available(iOS 14.0, macOS 11.0, *)
public struct APIErrorResponse: Decodable {
    public struct ErrorDetails: Decodable {
        public let message: String
        public let type: String?
        public let param: String?
        public let code: String?
    }
    
    public let error: ErrorDetails
}