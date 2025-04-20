# ``OpenAISwift``

A Swift library for the OpenAI API.

## Overview

OpenAISwift provides a convenient way to interact with the OpenAI API in Swift projects. It supports all major OpenAI endpoints and offers both async/await and closure-based APIs.

```swift
// Initialize with API key
let client = OpenAIClient(apiKey: "your-api-key")

// Send a chat completion request
let messages = [
    client.chat.systemMessage("You are a helpful assistant."),
    client.chat.userMessage("Hello, how are you?")
]

let response = try await client.chat.send(
    messages: messages,
    model: "gpt-4"
)

print(response.choices[0].message.content)
```

## Topics

### Essentials

- ``OpenAIClient``
- ``OpenAIConfiguration``

### Modules

- ``ChatModule``
- ``CompletionModule``
- ``EmbeddingsModule``
- ``ImagesModule``
- ``AudioModule``
- ``ModerationModule``

### Networking

- ``OpenAITransport``
- ``OpenAIError``

### Models

- ``ChatModels``
- ``CompletionModels``
- ``EmbeddingsModels``
- ``ImagesModels``
- ``AudioModels``
- ``ModerationModels``