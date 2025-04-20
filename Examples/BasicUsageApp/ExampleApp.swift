import SwiftUI
import OpenAISwift

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var prompt = ""
    @State private var apiKey = ""
    @State private var isConfigured = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !isConfigured {
                    configurationView
                } else {
                    chatView
                }
            }
            .navigationTitle("OpenAI Example")
            .padding()
        }
    }
    
    private var configurationView: some View {
        VStack(spacing: 20) {
            Text("Enter your OpenAI API Key to get started")
                .font(.headline)
            
            SecureField("API Key", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button("Configure") {
                viewModel.configure(with: apiKey)
                isConfigured = true
            }
            .disabled(apiKey.isEmpty)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var chatView: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        MessageView(message: message)
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding()
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Type a message", text: $prompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(viewModel.isLoading)
                
                Button(action: {
                    viewModel.sendMessage(prompt)
                    prompt = ""
                }) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(prompt.isEmpty || viewModel.isLoading)
            }
            .padding()
        }
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(10)
                .background(message.isUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

class ViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading = false
    
    private var client: OpenAIClient?
    
    func configure(with apiKey: String) {
        client = OpenAIClient(apiKey: apiKey)
        
        // Add a welcome message
        messages.append(Message(content: "Hello! I'm your AI assistant. How can I help you today?", isUser: false))
    }
    
    func sendMessage(_ content: String) {
        guard !content.isEmpty, let client = client else { return }
        
        // Add user message
        let userMessage = Message(content: content, isUser: true)
        messages.append(userMessage)
        
        // Convert to chat messages
        var chatMessages = [ChatModels.Message(role: .system, content: "You are a helpful assistant.")]
        
        for message in messages {
            let role: ChatModels.Message.Role = message.isUser ? .user : .assistant
            chatMessages.append(ChatModels.Message(role: role, content: message.content))
        }
        
        // Send to API
        isLoading = true
        
        Task {
            do {
                let response = try await client.chat.send(
                    messages: chatMessages,
                    model: "gpt-3.5-turbo",
                    temperature: 0.7
                )
                
                if let assistantResponse = response.choices.first?.message.content {
                    await MainActor.run {
                        messages.append(Message(content: assistantResponse, isUser: false))
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    messages.append(Message(content: "Error: \(error.localizedDescription)", isUser: false))
                    isLoading = false
                }
            }
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}