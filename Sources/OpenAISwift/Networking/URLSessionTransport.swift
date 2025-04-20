import Foundation

/// URLSession-based implementation of the OpenAITransport protocol
@available(iOS 14.0, macOS 11.0, *)
public class URLSessionTransport: OpenAITransport {
    private let session: URLSession
    
    /// Creates a new URLSessionTransport with the specified URLSession
    /// - Parameter session: The URLSession to use for network requests
    public init(session: URLSession = .shared) {
        self.session = session
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
    public func send(
        to endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String],
        configuration: OpenAIConfiguration
    ) async throws -> Data {
        let url = configuration.baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = configuration.timeoutInterval
        
        // Set default headers
        request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set organization if provided
        if let organization = configuration.organization {
            request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
        }
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body if provided
        request.httpBody = body
        
        do {
            let (data, response) = try await session.data(for: request)
            return try handleResponse(data: data, response: response)
        } catch {
            throw OpenAIError.networkError(error)
        }
    }
    
    /// Sends a multipart form data request to the OpenAI API
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - formData: The form data to send
    ///   - configuration: The OpenAI configuration
    /// - Returns: The response data
    /// - Throws: An error if the request fails
    public func sendMultipartFormData(
        to endpoint: String,
        formData: MultipartFormData,
        configuration: OpenAIConfiguration
    ) async throws -> Data {
        let url = configuration.baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.timeoutInterval = configuration.timeoutInterval
        
        // Set default headers
        request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Set organization if provided
        if let organization = configuration.organization {
            request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
        }
        
        // Generate boundary and set content type
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create multipart form data body
        request.httpBody = createMultipartFormData(formData: formData, boundary: boundary)
        
        do {
            let (data, response) = try await session.data(for: request)
            return try handleResponse(data: data, response: response)
        } catch {
            throw OpenAIError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func handleResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.unknown("Invalid response type")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw OpenAIError.authenticationError
        default:
            // Try to decode the error response
            do {
                let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw OpenAIError.apiError(errorResponse)
            } catch {
                if let error = error as? OpenAIError {
                    throw error
                } else {
                    throw OpenAIError.unknown("Status code: \(httpResponse.statusCode)")
                }
            }
        }
    }
    
    private func createMultipartFormData(formData: MultipartFormData, boundary: String) -> Data {
        var body = Data()
        
        for part in formData.parts {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            var contentDisposition = "Content-Disposition: form-data; name=\"\(part.name)\""
            if let filename = part.filename {
                contentDisposition += "; filename=\"\(filename)\""
            }
            body.append("\(contentDisposition)\r\n".data(using: .utf8)!)
            
            if let mimeType = part.mimeType {
                body.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
            }
            
            body.append("\r\n".data(using: .utf8)!)
            body.append(part.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}