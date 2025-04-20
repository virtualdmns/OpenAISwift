import Foundation

/// Module for interacting with the OpenAI Chat Completions API
@available(iOS 14.0, macOS 11.0, *)
public class ChatModule {
    private let client: OpenAIClient
    private let endpoint = "v1/chat/completions"
    
    /// Creates a new chat module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Sends a chat completion request to the OpenAI API
    /// - Parameters:
    ///   - messages: The messages to generate completions for
    ///   - model: The model to use (e.g., "gpt-4")
    ///   - maxTokens: The maximum number of tokens to generate
    ///   - temperature: The sampling temperature (0-2)
    ///   - topP: The nucleus sampling parameter (0-1)
    ///   - n: How many completions to generate
    ///   - stop: The stop sequences
    ///   - presencePenalty: The presence penalty (-2 to 2)
    ///   - frequencyPenalty: The frequency penalty (-2 to 2)
    ///   - logitBias: The logit bias
    ///   - user: The user identifier
    /// - Returns: The chat completion response
    /// - Throws: An error if the request fails
    public func send(
        messages: [ChatModels.Message],
        model: String = "gpt-3.5-turbo",
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        stop: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        logitBias: [String: Int]? = nil,
        user: String? = nil
    ) async throws -> ChatModels.CompletionResponse {
        let request = ChatModels.CompletionRequest(
            model: model,
            messages: messages,
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: false,
            stop: stop,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
        
        return try await client.send(
            to: endpoint,
            method: .post,
            body: request
        )
    }
    
    /// Sends a chat completion request to the OpenAI API with a completion handler
    /// - Parameters:
    ///   - messages: The messages to generate completions for
    ///   - model: The model to use (e.g., "gpt-4")
    ///   - maxTokens: The maximum number of tokens to generate
    ///   - temperature: The sampling temperature (0-2)
    ///   - topP: The nucleus sampling parameter (0-1)
    ///   - n: How many completions to generate
    ///   - stop: The stop sequences
    ///   - presencePenalty: The presence penalty (-2 to 2)
    ///   - frequencyPenalty: The frequency penalty (-2 to 2)
    ///   - logitBias: The logit bias
    ///   - user: The user identifier
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func send(
        messages: [ChatModels.Message],
        model: String = "gpt-3.5-turbo",
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        stop: [String]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        logitBias: [String: Int]? = nil,
        user: String? = nil,
        completion: @escaping (Result<ChatModels.CompletionResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await send(
                    messages: messages,
                    model: model,
                    maxTokens: maxTokens,
                    temperature: temperature,
                    topP: topP,
                    n: n,
                    stop: stop,
                    presencePenalty: presencePenalty,
                    frequencyPenalty: frequencyPenalty,
                    logitBias: logitBias,
                    user: user
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Creates a system message
    /// - Parameter content: The content of the message
    /// - Returns: A system message
    public func systemMessage(_ content: String) -> ChatModels.Message {
        return ChatModels.Message(role: .system, content: content)
    }
    
    /// Creates a user message
    /// - Parameters:
    ///   - content: The content of the message
    ///   - name: The name of the user (optional)
    /// - Returns: A user message
    public func userMessage(_ content: String, name: String? = nil) -> ChatModels.Message {
        return ChatModels.Message(role: .user, content: content, name: name)
    }
    
    /// Creates an assistant message
    /// - Parameters:
    ///   - content: The content of the message
    ///   - name: The name of the assistant (optional)
    /// - Returns: An assistant message
    public func assistantMessage(_ content: String, name: String? = nil) -> ChatModels.Message {
        return ChatModels.Message(role: .assistant, content: content, name: name)
    }
}