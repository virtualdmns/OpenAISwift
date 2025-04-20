import Foundation

/// Module for interacting with the OpenAI Images API
@available(iOS 14.0, macOS 11.0, *)
public class ImagesModule {
    private let client: OpenAIClient
    private let endpoint = "v1/images/generations"
    
    /// Creates a new images module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Generates images from a prompt
    /// - Parameters:
    ///   - prompt: The prompt to generate images for
    ///   - n: The number of images to generate
    ///   - size: The size of the generated images
    ///   - responseFormat: The format of the generated images
    ///   - user: The user identifier
    /// - Returns: The image generation response
    /// - Throws: An error if the request fails
    public func generate(
        prompt: String,
        n: Int = 1,
        size: ImagesModels.ImageSize = .medium,
        responseFormat: ImagesModels.ResponseFormat = .url,
        user: String? = nil
    ) async throws -> ImagesModels.GenerationResponse {
        let request = ImagesModels.GenerationRequest(
            prompt: prompt,
            n: n,
            size: size,
            responseFormat: responseFormat,
            user: user
        )
        
        return try await client.send(
            to: endpoint,
            method: .post,
            body: request
        )
    }
    
    /// Generates images from a prompt with a completion handler
    /// - Parameters:
    ///   - prompt: The prompt to generate images for
    ///   - n: The number of images to generate
    ///   - size: The size of the generated images
    ///   - responseFormat: The format of the generated images
    ///   - user: The user identifier
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func generate(
        prompt: String,
        n: Int = 1,
        size: ImagesModels.ImageSize = .medium,
        responseFormat: ImagesModels.ResponseFormat = .url,
        user: String? = nil,
        completion: @escaping (Result<ImagesModels.GenerationResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await generate(
                    prompt: prompt,
                    n: n,
                    size: size,
                    responseFormat: responseFormat,
                    user: user
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}