import Foundation

/// Module for interacting with the OpenAI Audio API
@available(iOS 14.0, macOS 11.0, *)
public class AudioModule {
    private let client: OpenAIClient
    private let transcriptionEndpoint = "v1/audio/transcriptions"
    private let translationEndpoint = "v1/audio/translations"
    
    /// Creates a new audio module
    /// - Parameter client: The OpenAI client
    internal init(client: OpenAIClient) {
        self.client = client
    }
    
    /// Transcribes audio to text
    /// - Parameters:
    ///   - audioData: The audio data to transcribe
    ///   - filename: The filename of the audio file
    ///   - model: The model to use (e.g., "whisper-1")
    ///   - prompt: An optional prompt to guide the transcription
    ///   - responseFormat: The format of the response
    ///   - temperature: The sampling temperature
    ///   - language: The language of the audio
    /// - Returns: The transcription response
    /// - Throws: An error if the request fails
    public func transcribe(
        audioData: Data,
        filename: String,
        model: String = "whisper-1",
        prompt: String? = nil,
        responseFormat: AudioModels.ResponseFormat = .json,
        temperature: Double? = nil,
        language: String? = nil
    ) async throws -> AudioModels.TranscriptionResponse {
        var parts: [MultipartFormData.Part] = [
            MultipartFormData.Part(
                name: "file",
                filename: filename,
                mimeType: mimeType(for: filename),
                data: audioData
            ),
            MultipartFormData.Part(
                name: "model",
                data: model.data(using: .utf8)!
            ),
            MultipartFormData.Part(
                name: "response_format",
                data: responseFormat.rawValue.data(using: .utf8)!
            )
        ]
        
        if let prompt = prompt {
            parts.append(MultipartFormData.Part(
                name: "prompt",
                data: prompt.data(using: .utf8)!
            ))
        }
        
        if let temperature = temperature {
            parts.append(MultipartFormData.Part(
                name: "temperature",
                data: String(temperature).data(using: .utf8)!
            ))
        }
        
        if let language = language {
            parts.append(MultipartFormData.Part(
                name: "language",
                data: language.data(using: .utf8)!
            ))
        }
        
        let formData = MultipartFormData(parts: parts)
        
        return try await client.sendMultipartFormData(
            to: transcriptionEndpoint,
            formData: formData
        )
    }
    
    /// Translates audio to English text
    /// - Parameters:
    ///   - audioData: The audio data to translate
    ///   - filename: The filename of the audio file
    ///   - model: The model to use (e.g., "whisper-1")
    ///   - prompt: An optional prompt to guide the translation
    ///   - responseFormat: The format of the response
    ///   - temperature: The sampling temperature
    /// - Returns: The translation response
    /// - Throws: An error if the request fails
    public func translate(
        audioData: Data,
        filename: String,
        model: String = "whisper-1",
        prompt: String? = nil,
        responseFormat: AudioModels.ResponseFormat = .json,
        temperature: Double? = nil
    ) async throws -> AudioModels.TranslationResponse {
        var parts: [MultipartFormData.Part] = [
            MultipartFormData.Part(
                name: "file",
                filename: filename,
                mimeType: mimeType(for: filename),
                data: audioData
            ),
            MultipartFormData.Part(
                name: "model",
                data: model.data(using: .utf8)!
            ),
            MultipartFormData.Part(
                name: "response_format",
                data: responseFormat.rawValue.data(using: .utf8)!
            )
        ]
        
        if let prompt = prompt {
            parts.append(MultipartFormData.Part(
                name: "prompt",
                data: prompt.data(using: .utf8)!
            ))
        }
        
        if let temperature = temperature {
            parts.append(MultipartFormData.Part(
                name: "temperature",
                data: String(temperature).data(using: .utf8)!
            ))
        }
        
        let formData = MultipartFormData(parts: parts)
        
        return try await client.sendMultipartFormData(
            to: translationEndpoint,
            formData: formData
        )
    }
    
    /// Transcribes audio to text with a completion handler
    /// - Parameters:
    ///   - audioData: The audio data to transcribe
    ///   - filename: The filename of the audio file
    ///   - model: The model to use (e.g., "whisper-1")
    ///   - prompt: An optional prompt to guide the transcription
    ///   - responseFormat: The format of the response
    ///   - temperature: The sampling temperature
    ///   - language: The language of the audio
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func transcribe(
        audioData: Data,
        filename: String,
        model: String = "whisper-1",
        prompt: String? = nil,
        responseFormat: AudioModels.ResponseFormat = .json,
        temperature: Double? = nil,
        language: String? = nil,
        completion: @escaping (Result<AudioModels.TranscriptionResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await transcribe(
                    audioData: audioData,
                    filename: filename,
                    model: model,
                    prompt: prompt,
                    responseFormat: responseFormat,
                    temperature: temperature,
                    language: language
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Translates audio to English text with a completion handler
    /// - Parameters:
    ///   - audioData: The audio data to translate
    ///   - filename: The filename of the audio file
    ///   - model: The model to use (e.g., "whisper-1")
    ///   - prompt: An optional prompt to guide the translation
    ///   - responseFormat: The format of the response
    ///   - temperature: The sampling temperature
    ///   - completion: The completion handler to call with the result
    /// - Returns: A task that can be cancelled
    @discardableResult
    public func translate(
        audioData: Data,
        filename: String,
        model: String = "whisper-1",
        prompt: String? = nil,
        responseFormat: AudioModels.ResponseFormat = .json,
        temperature: Double? = nil,
        completion: @escaping (Result<AudioModels.TranslationResponse, Error>) -> Void
    ) -> Task<Void, Never> {
        return Task {
            do {
                let response = try await translate(
                    audioData: audioData,
                    filename: filename,
                    model: model,
                    prompt: prompt,
                    responseFormat: responseFormat,
                    temperature: temperature
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func mimeType(for filename: String) -> String {
        let ext = (filename as NSString).pathExtension.lowercased()
        switch ext {
        case "mp3": return "audio/mpeg"
        case "mp4": return "audio/mp4"
        case "mpeg": return "audio/mpeg"
        case "mpga": return "audio/mpeg"
        case "m4a": return "audio/mp4"
        case "wav": return "audio/wav"
        case "webm": return "audio/webm"
        default: return "application/octet-stream"
        }
    }
}