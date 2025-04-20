# OpenAISwift

A Swift library for the OpenAI API. This package provides a convenient way to interact with the OpenAI API in Swift projects.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2014.0+%20|%20macOS%2011.0+-4E4E4E.svg)](https://developer.apple.com)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🔑 Secure API key management
- 💬 Chat completions API
- ✍️ Text completions API
- 🔤 Embeddings API
- 🖼️ Image generation API
- 🎤 Audio transcription and translation API
- 🛡️ Content moderation API
- ⚡️ Async/await and closure-based APIs
- 🧪 Fully testable with dependency injection
- 📚 Complete documentation

## Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/virtualdmns/OpenAISwift.git", from: "0.1.0")
]
```

Or add it directly in Xcode using File > Add Packages...

## Usage

### API Key Management with Secrets.plist

This package supports storing API keys in a .plist file that is excluded from version control:

1. Copy the template file `Secrets.plist.example` to `Secrets.plist` in your project's root directory
2. Add your API key to the Secrets.plist file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>OPENAI_API_KEY</key>
	<string>your-api-key-here</string>
	<key>OPENAI_ORGANIZATION</key>
	<string>your-organization-id-here</string>
</dict>
</plist>
```

3. Initialize the client without providing the API key:

```swift
// The client will automatically use the API key from Secrets.plist
if let client = OpenAIClient() {
    // Use the client
} else {
    // Handle the case where Secrets.plist is not found or invalid
}
```

### Configuration

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

```swift
// Using async/await
do {
    let messages = [
        client.chat.systemMessage("You are a helpful assistant."),
        client.chat.userMessage("Hello, how are you?")
    ]
    
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

## Testing

The library is designed to be easily testable with dependency injection:

```swift
// Create a mock transport for testing
let mockTransport = MockTransport()

// Set up the expected response
try mockTransport.setResponse(json: "{ ... }")

// Create a client with the mock transport
let client = OpenAIClient(
    configuration: OpenAIConfiguration(apiKey: "test-key"),
    transport: mockTransport
)

// Test your code using the client
```

## Documentation

Full documentation is available via DocC. Open the package in Xcode and build the documentation from the Product menu.

## License

OpenAISwift is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
