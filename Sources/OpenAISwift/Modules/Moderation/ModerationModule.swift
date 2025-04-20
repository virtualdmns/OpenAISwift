import Foundation

/// Module for interacting with the OpenAI Moderation API
@available(iOS 14.0, macOS 11.0, *)
public class ModerationModule {
    private let client: OpenAIClient
    private let endpoint = "v1/moderations"
    
    /// Creates a new moderation module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Moderates content for policy violations
    /// - Parameters:
    ///   - input: The input to moderate (single string)
    ///   - model: The model to use
    /// - Returns: The moderation response
    /// - Throws: An error if the request fails
    public func moderate(
        input: String,
        model: String? = nil
    ) async throws -> ModerationModels.ModerationResponse {
        return try await moderate(input: [input], model: model)
    }
    
    /// Moderates content for policy violations
    /// - Parameters:
    ///   - input: The input to moderate (array of strings)
    ///   - model: The model to use
    /// - Returns: The moderation response
    /// - Throws: An error if the request fails
    public func moderate(
        input: [String],
        model: String? = nil
    ) async throws -> ModerationModels.ModerationResponse {
        let request = ModerationModels.ModerationRequest(
            input: input,
            model: model
        )
        
        return try await client.send(
            to: endpoint,
            method: .post,
            body: request
        )
    }
    
    /// Moderates content for policy violations with a completion handler
    /// - Parameters:
    ///   - input: The input to moderate (single string)
    ///   - model: The model to use
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func moderate(
        input: String,
        model: String? = nil,
        completion: @escaping (Result<ModerationModels.ModerationResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return moderate(input: [input], model: model, completion: completion)
    }
    
    /// Moderates content for policy violations with a completion handler
    /// - Parameters:
    ///   - input: The input to moderate (array of strings)
    ///   - model: The model to use
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func moderate(
        input: [String],
        model: String? = nil,
        completion: @escaping (Result<ModerationModels.ModerationResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await moderate(
                    input: input,
                    model: model
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}