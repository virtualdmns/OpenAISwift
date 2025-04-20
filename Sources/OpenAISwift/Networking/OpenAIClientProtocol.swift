import Foundation

/// Protocol defining the network transport layer for OpenAI API requests
@available(iOS 14.0, macOS 11.0, *)
public protocol OpenAITransport {
    /// Sends a request to the OpenAI API and returns the response
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: The HTTP method
    ///   - body: Optional request body
    ///   - headers: Additional headers to include
    ///   - configuration: The OpenAI configuration
    /// - Returns: The response data
    /// - Throws: An error if the request fails
    func send(
        to endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String],
        configuration: OpenAIConfiguration
    ) async throws -> Data
    
    /// Sends a multipart form data request to the OpenAI API
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - formData: The form data to send
    ///   - configuration: The OpenAI configuration
    /// - Returns: The response data
    /// - Throws: An error if the request fails
    func sendMultipartFormData(
        to endpoint: String,
        formData: MultipartFormData,
        configuration: OpenAIConfiguration
    ) async throws -> Data
}

/// HTTP methods supported by the OpenAI API
@available(iOS 14.0, macOS 11.0, *)
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

/// Represents multipart form data for file uploads
@available(iOS 14.0, macOS 11.0, *)
public struct MultipartFormData {
    public struct Part {
        public let name: String
        public let filename: String?
        public let mimeType: String?
        public let data: Data
        
        public init(name: String, filename: String? = nil, mimeType: String? = nil, data: Data) {
            self.name = name
            self.filename = filename
            self.mimeType = mimeType
            self.data = data
        }
    }
    
    public let parts: [Part]
    
    public init(parts: [Part]) {
        self.parts = parts
    }
}