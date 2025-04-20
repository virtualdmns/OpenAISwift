import Foundation

/// Models for the Audio API
@available(iOS 14.0, macOS 11.0, *)
public enum AudioModels {
    /// Response format for audio transcription and translation
    public enum ResponseFormat: String, Codable {
        case json
        case text
        case srt
        case verboseJson = "verbose_json"
        case vtt
    }
    
    /// Response from the audio transcription API
    public struct TranscriptionResponse: Decodable {
        /// The transcribed text
        public let text: String
    }
    
    /// Response from the audio translation API
    public struct TranslationResponse: Decodable {
        /// The translated text
        public let text: String
    }
}