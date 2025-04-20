# Getting Started with OpenAISwift

Learn how to integrate and use the OpenAISwift library in your projects.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/OpenAISwift.git", from: "0.1.0")
]
```

Or add it directly in Xcode using File > Add Packages...

## Basic Usage

### Configuration

First, import the library and create an OpenAI client:

```swift
import OpenAISwift

// Initialize with API key
let client = OpenAIClient(apiKey: "your-api-key")

// Or with more options
let configuration = OpenAIConfiguration(
    apiKey: "your-api-key",
    organization: "your-organization-id", // Optional
    timeoutInterval: 30.0 // Optional
)
let client = OpenAIClient(configuration: configuration)
```

### Chat Completions

Use the chat module to interact with the chat completions API:

```swift
// Create messages
let messages = [
    client.chat.systemMessage("You are a helpful assistant."),
    client.chat.userMessage("Hello, how are you?")
]

// Using async/await
do {
    let response = try await client.chat.send(
        messages: messages,
        model: "gpt-4",
        temperature: 0.7
    )
    
    print(response.choices[0].message.content)
} catch {
    print("Error: \(error)")
}

// Using completion handler
client.chat.send(
    messages: messages,
    model: "gpt-4"
) { result in
    switch result {
    case .success(let response):
        print(response.choices[0].message.content)
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### Text Completions

Use the completions module for text completions:

```swift
do {
    let response = try await client.completions.send(
        prompt: "Once upon a time",
        model: "text-davinci-003",
        maxTokens: 100
    )
    
    print(response.choices[0].text)
} catch {
    print("Error: \(error)")
}
```

### Embeddings

Generate embeddings for text:

```swift
do {
    let response = try await client.embeddings.create(
        input: ["Hello world", "OpenAI is awesome"],
        model: "text-embedding-ada-002"
    )
    
    for embedding in response.data {
        print("Embedding \(embedding.index): \(embedding.embedding.count) dimensions")
    }
} catch {
    print("Error: \(error)")
}
```

### Image Generation

Generate images from text prompts:

```swift
do {
    let response = try await client.images.generate(
        prompt: "A cute cat sitting on a windowsill",
        n: 1,
        size: .large
    )
    
    if let url = response.data.first?.url {
        print("Image URL: \(url)")
    }
} catch {
    print("Error: \(error)")
}
```

### Audio Transcription

Transcribe audio to text:

```swift
do {
    let audioURL = URL(fileURLWithPath: "/path/to/audio.mp3")
    let audioData = try Data(contentsOf: audioURL)
    
    let response = try await client.audio.transcribe(
        audioData: audioData,
        filename: "audio.mp3",
        model: "whisper-1"
    )
    
    print("Transcription: \(response.text)")
} catch {
    print("Error: \(error)")
}
```

### Content Moderation

Check content for policy violations:

```swift
do {
    let response = try await client.moderation.moderate(
        input: "Some text to check for policy violations"
    )
    
    if response.results.first?.flagged == true {
        print("Content was flagged")
    } else {
        print("Content is safe")
    }
} catch {
    print("Error: \(error)")
}
```

## Error Handling

The library uses the `OpenAIError` enum for error handling:

```swift
do {
    let response = try await client.chat.send(messages: messages)
    // Handle response
} catch let error as OpenAIError {
    switch error {
    case .apiError(let apiError):
        print("API Error: \(apiError.error.message)")
    case .networkError(let underlyingError):
        print("Network Error: \(underlyingError)")
    case .decodingError(let underlyingError):
        print("Decoding Error: \(underlyingError)")
    case .authenticationError:
        print("Authentication Error: Invalid API key")
    default:
        print("Other Error: \(error)")
    }
} catch {
    print("Unexpected Error: \(error)")
}
```