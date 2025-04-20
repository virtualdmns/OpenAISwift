import Foundation

/// Module for interacting with the OpenAI Text Completions API
@available(iOS 14.0, macOS 11.0, *)
public class CompletionModule {
    private let client: OpenAIClient
    private let endpoint = "v1/completions"
    
    /// Creates a new completion module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Sends a text completion request to the OpenAI API
    /// - Parameters:
    ///   - prompt: The prompt to generate completions for
    ///   - model: The model to use (e.g., "text-davinci-003")
    ///   - maxTokens: The maximum number of tokens to generate
    ///   - temperature: The sampling temperature (0-2)
    ///   - topP: The nucleus sampling parameter (0-1)
    ///   - n: How many completions to generate
    ///   - logprobs: The log probabilities
    ///   - echo: Whether to include the prompt in the response
    ///   - stop: The stop sequences
    ///   - presencePenalty: The presence penalty (-2 to 2)
    ///   - frequencyPenalty: The frequency penalty (-2 to 2)
    ///   - bestOf: The best of parameter
    ///   - logitBias: The logit bias
    ///   - user: The user identifier
    /// - Returns: The text completion response
    /// - Throws: An error if the request fails
    public func send(
        prompt: String,
        model: String = "text-davinci-003",
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        logprobs: Int? = nil,
        echo: Bool? = nil,
        stop: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        bestOf: Int? = nil,
        logitBias: [String: Int]? = nil,
        user: String? = nil
    ) async throws -> CompletionModels.CompletionResponse {
        let request = CompletionModels.CompletionRequest(
            model: model,
            prompt: prompt,
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: false,
            logprobs: logprobs,
            echo: echo,
            stop: stop,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            bestOf: bestOf,
            logitBias: logitBias,
            user: user
        )
        
        return try await client.send(
            to: endpoint,
            method: .post,
            body: request
        )
    }
    
    /// Sends a text completion request to the OpenAI API with a completion handler
    /// - Parameters:
    ///   - prompt: The prompt to generate completions for
    ///   - model: The model to use (e.g., "text-davinci-003")
    ///   - maxTokens: The maximum number of tokens to generate
    ///   - temperature: The sampling temperature (0-2)
    ///   - topP: The nucleus sampling parameter (0-1)
    ///   - n: How many completions to generate
    ///   - logprobs: The log probabilities
    ///   - echo: Whether to include the prompt in the response
    ///   - stop: The stop sequences
    ///   - presencePenalty: The presence penalty (-2 to 2)
    ///   - frequencyPenalty: The frequency penalty (-2 to 2)
    ///   - bestOf: The best of parameter
    ///   - logitBias: The logit bias
    ///   - user: The user identifier
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func send(
        prompt: String,
        model: String = "text-davinci-003",
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        logprobs: Int? = nil,
        echo: Bool? = nil,
        stop: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        bestOf: Int? = nil,
        logitBias: [String: Int]? = nil,
        user: String? = nil,
        completion: @escaping (Result<CompletionModels.CompletionResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await send(
                    prompt: prompt,
                    model: model,
                    maxTokens: maxTokens,
                    temperature: temperature,
                    topP: topP,
                    n: n,
                    logprobs: logprobs,
                    echo: echo,
                    stop: stop,
                    presencePenalty: presencePenalty,
                    frequencyPenalty: frequencyPenalty,
                    bestOf: bestOf,
                    logitBias: logitBias,
                    user: user
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}