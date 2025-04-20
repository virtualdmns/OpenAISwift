import Foundation

/// Configuration for the OpenAI API client
@available(iOS 14.0, macOS 11.0, *)
public struct OpenAIConfiguration {
    /// The API key used for authentication with OpenAI services
    public let apiKey: String
    
    /// The base URL for the OpenAI API
    public let baseURL: URL
    
    /// The organization ID (optional)
    public let organization: String?
    
    /// Default timeout interval for requests in seconds
    public let timeoutInterval: TimeInterval
    
    /// Creates a new OpenAI configuration
    /// - Parameters:
    ///   - apiKey: Your OpenAI API key
    ///   - organization: Optional organization ID
    ///   - baseURL: Base URL for the API (defaults to OpenAI's API)
    ///   - timeoutInterval: Request timeout in seconds (defaults to 60)
    public init(
        apiKey: String,
        organization: String? = nil,
        baseURL: URL = URL(string: "https://api.openai.com")!,
        timeoutInterval: TimeInterval = 60.0
    ) {
        self.apiKey = apiKey
        self.organization = organization
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
    }
}