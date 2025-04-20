import XCTest
@testable import OpenAISwift

@available(iOS 14.0, macOS 11.0, *)
final class OpenAIClientTests: XCTestCase {
    var mockTransport: MockTransport!
    var client: OpenAIClient!
    
    override func setUp() {
        super.setUp()
        mockTransport = MockTransport()
        client = OpenAIClient(
            configuration: OpenAIConfiguration(apiKey: "test-api-key"),
            transport: mockTransport
        )
    }
    
    override func tearDown() {
        mockTransport = nil
        client = nil
        super.tearDown()
    }
    
    func testChatCompletion() async throws {
        // Prepare mock response
        let responseJSON = """
        {
            "id": "chatcmpl-123",
            "object": "chat.completion",
            "created": 1677652288,
            "model": "gpt-3.5-turbo",
            "choices": [{
                "index": 0,
                "message": {
                    "role": "assistant",
                    "content": "Hello, how can I help you today?"
                },
                "finish_reason": "stop"
            }],
            "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 10,
                "total_tokens": 20
            }
        }
        """
        try mockTransport.setResponse(json: responseJSON)
        
        // Create messages
        let messages = [
            ChatModels.Message(role: .user, content: "Hello!")
        ]
        
        // Send request
        let response = try await client.chat.send(messages: messages)
        
        // Verify response
        XCTAssertEqual(response.choices.count, 1)
        XCTAssertEqual(response.choices[0].message.content, "Hello, how can I help you today?")
        XCTAssertEqual(response.choices[0].message.role, .assistant)
    }
    
    func testTextCompletion() async throws {
        // Prepare mock response
        let responseJSON = """
        {
            "id": "cmpl-123",
            "object": "text_completion",
            "created": 1677652288,
            "model": "text-davinci-003",
            "choices": [{
                "index": 0,
                "text": "This is a test completion.",
                "finish_reason": "stop"
            }],
            "usage": {
                "prompt_tokens": 5,
                "completion_tokens": 7,
                "total_tokens": 12
            }
        }
        """
        try mockTransport.setResponse(json: responseJSON)
        
        // Send request
        let response = try await client.completions.send(prompt: "Hello")
        
        // Verify response
        XCTAssertEqual(response.choices.count, 1)
        XCTAssertEqual(response.choices[0].text, "This is a test completion.")
    }
    
    func testEmbeddings() async throws {
        // Prepare mock response
        let responseJSON = """
        {
            "object": "list",
            "model": "text-embedding-ada-002",
            "data": [{
                "object": "embedding",
                "embedding": [0.1, 0.2, 0.3],
                "index": 0
            }],
            "usage": {
                "prompt_tokens": 5,
                "total_tokens": 5
            }
        }
        """
        try mockTransport.setResponse(json: responseJSON)
        
        // Send request
        let response = try await client.embeddings.create(input: "Hello")
        
        // Verify response
        XCTAssertEqual(response.data.count, 1)
        XCTAssertEqual(response.data[0].embedding, [0.1, 0.2, 0.3])
    }
    
    func testImageGeneration() async throws {
        // Prepare mock response
        let responseJSON = """
        {
            "created": 1677652288,
            "data": [{
                "url": "https://example.com/image.png"
            }]
        }
        """
        try mockTransport.setResponse(json: responseJSON)
        
        // Send request
        let response = try await client.images.generate(prompt: "A cute cat")
        
        // Verify response
        XCTAssertEqual(response.data.count, 1)
        XCTAssertEqual(response.data[0].url, "https://example.com/image.png")
    }
    
    func testModeration() async throws {
        // Prepare mock response
        let responseJSON = """
        {
            "id": "modr-123",
            "model": "text-moderation-latest",
            "results": [{
                "flagged": false,
                "categories": {
                    "hate": false,
                    "hate/threatening": false,
                    "self-harm": false,
                    "sexual": false,
                    "sexual/minors": false,
                    "violence": false,
                    "violence/graphic": false
                },
                "category_scores": {
                    "hate": 0.01,
                    "hate/threatening": 0.01,
                    "self-harm": 0.01,
                    "sexual": 0.01,
                    "sexual/minors": 0.01,
                    "violence": 0.01,
                    "violence/graphic": 0.01
                }
            }]
        }
        """
        try mockTransport.setResponse(json: responseJSON)
        
        // Send request
        let response = try await client.moderation.moderate(input: "Hello")
        
        // Verify response
        XCTAssertEqual(response.results.count, 1)
        XCTAssertFalse(response.results[0].flagged)
    }
}