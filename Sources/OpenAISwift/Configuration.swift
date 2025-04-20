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
    
    /// Creates a new OpenAI configuration from a Secrets.plist file
    /// - Returns: A configuration with API key and organization from the plist file
    public static func fromSecretsPlist() -> OpenAIConfiguration? {
        // Look for Secrets.plist in various locations
        let possiblePaths = [
            // Current directory
            "Secrets.plist",
            // Bundle resources
            Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            // Project directory
            FileManager.default.currentDirectoryPath + "/Secrets.plist"
        ].compactMap { $0 }
        
        for path in possiblePaths {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
               let apiKey = dict["OPENAI_API_KEY"] as? String {
                let organization = dict["OPENAI_ORGANIZATION"] as? String
                return OpenAIConfiguration(apiKey: apiKey, organization: organization)
            }
        }
        
        return nil
    }
}