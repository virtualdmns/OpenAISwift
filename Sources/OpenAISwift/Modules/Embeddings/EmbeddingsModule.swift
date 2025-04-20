import Foundation

/// Module for interacting with the OpenAI Embeddings API
@available(iOS 14.0, macOS 11.0, *)
public class EmbeddingsModule {
    private let client: OpenAIClient
    private let endpoint = "v1/embeddings"
    
    /// Creates a new embeddings module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Sends an embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The input to embed (single string)
    ///   - model: The model to use (e.g., "text-embedding-ada-002")
    ///   - user: The user identifier
    /// - Returns: The embeddings response
    /// - Throws: An error if the request fails
    public func create(
        input: String,
        model: String = "text-embedding-ada-002",
        user: String? = nil
    ) async throws -> EmbeddingsModels.EmbeddingsResponse {
        return try await create(input: [input], model: model, user: user)
    }
    
    /// Sends an embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The input to embed (array of strings)
    ///   - model: The model to use (e.g., "text-embedding-ada-002")
    ///   - user: The user identifier
    /// - Returns: The embeddings response
    /// - Throws: An error if the request fails
    public func create(
        input: [String],
        model: String = "text-embedding-ada-002",
        user: String? = nil
    ) async throws -> EmbeddingsModels.EmbeddingsResponse {
        let request = EmbeddingsModels.EmbeddingsRequest(
            model: model,
            input: input,
            user: user
        )
        
        return try await client.send(
            to: endpoint,
            method: .post,
            body: request
        )
    }
    
    /// Sends an embeddings request to the OpenAI API with a completion handler
    /// - Parameters:
    ///   - input: The input to embed (single string)
    ///   - model: The model to use (e.g., "text-embedding-ada-002")
    ///   - user: The user identifier
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func create(
        input: String,
        model: String = "text-embedding-ada-002",
        user: String? = nil,
        completion: @escaping (Result<EmbeddingsModels.EmbeddingsResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return create(input: [input], model: model, user: user, completion: completion)
    }
    
    /// Sends an embeddings request to the OpenAI API with a completion handler
    /// - Parameters:
    ///   - input: The input to embed (array of strings)
    ///   - model: The model to use (e.g., "text-embedding-ada-002")
    ///   - user: The user identifier
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func create(
        input: [String],
        model: String = "text-embedding-ada-002",
        user: String? = nil,
        completion: @escaping (Result<EmbeddingsModels.EmbeddingsResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await create(
                    input: input,
                    model: model,
                    user: user
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}