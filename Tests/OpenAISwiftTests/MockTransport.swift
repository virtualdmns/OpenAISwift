import Foundation
@testable import OpenAISwift

/// A mock transport for testing
@available(iOS 14.0, macOS 11.0, *)
class MockTransport: OpenAITransport {
    /// The response to return
    var responseData: Data
    
    /// The error to throw
    var error: Error?
    
    /// The last request sent
    private(set) var lastRequest: MockRequest?
    
    /// A mock request
    struct MockRequest {
        let endpoint: String
        let method: HTTPMethod
        let body: Data?
        let headers: [String: String]
        let configuration: OpenAIConfiguration
    }
    
    /// Creates a new mock transport
    /// - Parameters:
    ///   - responseData: The response data to return
    ///   - error: The error to throw
    init(responseData: Data = Data(), error: Error? = nil) {
        self.responseData = responseData
        self.error = error
    }
    
    /// Sets the response to return
    /// - Parameter json: The JSON string to return
    /// - Throws: An error if the JSON is invalid
    func setResponse(json: String) throws {
        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "MockTransport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }
        self.responseData = data
    }
    
    /// Sets the response to return
    /// - Parameter object: The object to encode and return
    /// - Throws: An error if the object can't be encoded
    func setResponse<T: Encodable>(object: T) throws {
        self.responseData = try JSONEncoder().encode(object)
    }
    
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
    ) async throws -> Data {
        lastRequest = MockRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            headers: headers,
            configuration: configuration
        )
        
        if let error = error {
            throw error
        }
        
        return responseData
    }
    
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
    ) async throws -> Data {
        if let error = error {
            throw error
        }
        
        return responseData
    }
}