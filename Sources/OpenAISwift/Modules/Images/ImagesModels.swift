import Foundation

/// Models for the Images API
@available(iOS 14.0, macOS 11.0, *)
public enum ImagesModels {
    /// The size of the generated image
    public enum ImageSize: String, Codable {
        case small = "256x256"
        case medium = "512x512"
        case large = "1024x1024"
    }
    
    /// The format of the generated image
    public enum ResponseFormat: String, Codable {
        case url
        case b64Json = "b64_json"
    }
    
    /// Request for the image generations API
    public struct GenerationRequest: Codable {
        /// The prompt to generate images for
        public let prompt: String
        
        /// The number of images to generate
        public let n: Int?
        
        /// The size of the generated images
        public let size: ImageSize?
        
        /// The format of the generated images
        public let responseFormat: ResponseFormat?
        
        /// The user identifier
        public let user: String?
        
        /// Creates a new image generation request
        /// - Parameters:
        ///   - prompt: The prompt to generate images for
        ///   - n: The number of images to generate
        ///   - size: The size of the generated images
        ///   - responseFormat: The format of the generated images
        ///   - user: The user identifier
        public init(
            prompt: String,
            n: Int? = nil,
            size: ImageSize? = nil,
            responseFormat: ResponseFormat? = nil,
            user: String? = nil
        ) {
            self.prompt = prompt
            self.n = n
            self.size = size
            self.responseFormat = responseFormat
            self.user = user
        }
        
        enum CodingKeys: String, CodingKey {
            case prompt
            case n
            case size
            case responseFormat = "response_format"
            case user
        }
    }
    
    /// Response from the image generations API
    public struct GenerationResponse: Decodable {
        /// The creation timestamp
        public let created: Int
        
        /// The images generated
        public let data: [ImageData]
        
        /// Data for a generated image
        public struct ImageData: Decodable {
            /// The URL of the generated image
            public let url: String?
            
            /// The base64-encoded image data
            public let b64Json: String?
            
            enum CodingKeys: String, CodingKey {
                case url
                case b64Json = "b64_json"
            }
        }
    }
}