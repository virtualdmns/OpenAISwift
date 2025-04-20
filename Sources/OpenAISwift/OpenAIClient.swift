import Foundation

/// The main client for interacting with the OpenAI API
@available(iOS 14.0, macOS 11.0, *)
public class OpenAIClient {
    /// The configuration for the client
    public let configuration: OpenAIConfiguration
    
    /// The transport layer used for network requests
    private let transport: OpenAITransport
    
    /// The chat module for interacting with chat completions API
    public lazy var chat: ChatModule = ChatModule(client: self)
    
    /// The completions module for interacting with text completions API
    public lazy var completions: CompletionModule = CompletionModule(client: self)
    
    /// The embeddings module for interacting with embeddings API
    public lazy var embeddings: EmbeddingsModule = EmbeddingsModule(client: self)
    
    /// The images module for interacting with image generation API
    public lazy var images: ImagesModule = ImagesModule(client: self)
    
    /// The audio module for interacting with audio transcription and translation API
    public lazy var audio: AudioModule = AudioModule(client: self)
    
    /// The moderation module for interacting with content moderation API
    public lazy var moderation: ModerationModule = ModerationModule(client: self)
    
    /// Creates a new OpenAI client with the specified configuration and transport
    /// - Parameters:
    ///   - configuration: The configuration for the client
    ///   - transport: The transport layer to use for network requests
    public init(configuration: OpenAIConfiguration, transport: OpenAITransport? = nil) {
        self.configuration = configuration
        self.transport = transport ?? URLSessionTransport()
    }
    
    /// Creates a new OpenAI client with the specified API key
    /// - Parameters:
    ///   - apiKey: Your OpenAI API key
    ///   - organization: Optional organization ID
    public convenience init(apiKey: String, organization: String? = nil) {
        let configuration = OpenAIConfiguration(apiKey: apiKey, organization: organization)
        self.init(configuration: configuration)
    }
    
    /// Creates a new OpenAI client using the API key from Secrets.plist
    /// - Returns: A configured OpenAI client or nil if the Secrets.plist file is not found or invalid
    public convenience init?() {
        guard let configuration = OpenAIConfiguration.fromSecretsPlist() else {
            return nil
        }
        self.init(configuration: configuration)
    }
    
    /// Sends a request to the OpenAI API
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: The HTTP method
    ///   - body: The request body
    ///   - headers: Additional headers to include
    /// - Returns: The decoded response
    /// - Throws: An error if the request fails
    internal func send<Request: Encodable, Response: Decodable>(
        to endpoint: String,
        method: HTTPMethod,
        body: Request?,
        headers: [String: String] = [:]
    ) async throws -> Response {
        let bodyData: Data?
        if let body = body {
            do {
                bodyData = try JSONEncoder().encode(body)
            } catch {
                throw OpenAIError.encodingError(error)
            }
        } else {
            bodyData = nil
        }
        
        let responseData = try await transport.send(
            to: endpoint,
            method: method,
            body: bodyData,
            headers: headers,
            configuration: configuration
        )
        
        do {
            return try JSONDecoder().decode(Response.self, from: responseData)
        } catch {
            throw OpenAIError.decodingError(error)
        }
    }
    
    /// Sends a multipart form data request to the OpenAI API
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - formData: The form data to send
    /// - Returns: The decoded response
    /// - Throws: An error if the request fails
    internal func sendMultipartFormData<Response: Decodable>(
        to endpoint: String,
        formData: MultipartFormData
    ) async throws -> Response {
        let responseData = try await transport.sendMultipartFormData(
            to: endpoint,
            formData: formData,
            configuration: configuration
        )
        
        do {
            return try JSONDecoder().decode(Response.self, from: responseData)
        } catch {
            throw OpenAIError.decodingError(error)
        }
    }
}