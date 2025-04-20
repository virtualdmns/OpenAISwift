import Foundation

/// Models for the Moderation API
@available(iOS 14.0, macOS 11.0, *)
public enum ModerationModels {
    /// Request for the moderation API
    public struct ModerationRequest: Codable {
        /// The input to moderate
        public let input: [String]
        
        /// The model to use
        public let model: String?
        
        /// Creates a new moderation request
        /// - Parameters:
        ///   - input: The input to moderate
        ///   - model: The model to use
        public init(input: [String], model: String? = nil) {
            self.input = input
            self.model = model
        }
    }
    
    /// Response from the moderation API
    public struct ModerationResponse: Decodable {
        /// The ID of the moderation
        public let id: String
        
        /// The model used
        public let model: String
        
        /// The results of the moderation
        public let results: [Result]
        
        /// A moderation result
        public struct Result: Decodable {
            /// Whether the content was flagged
            public let flagged: Bool
            
            /// The categories that were flagged
            public let categories: Categories
            
            /// The category scores
            public let categoryScores: CategoryScores
            
            /// The categories that can be flagged
            public struct Categories: Decodable {
                /// Whether the content contains hate speech
                public let hate: Bool
                
                /// Whether the content contains hate/threatening speech
                public let hateThreatening: Bool
                
                /// Whether the content contains self-harm
                public let selfHarm: Bool
                
                /// Whether the content contains sexual content
                public let sexual: Bool
                
                /// Whether the content contains sexual content involving minors
                public let sexualMinors: Bool
                
                /// Whether the content contains violence
                public let violence: Bool
                
                /// Whether the content contains graphic violence
                public let violenceGraphic: Bool
                
                enum CodingKeys: String, CodingKey {
                    case hate
                    case hateThreatening = "hate/threatening"
                    case selfHarm = "self-harm"
                    case sexual
                    case sexualMinors = "sexual/minors"
                    case violence
                    case violenceGraphic = "violence/graphic"
                }
            }
            
            /// The scores for each category
            public struct CategoryScores: Decodable {
                /// The hate speech score
                public let hate: Double
                
                /// The hate/threatening speech score
                public let hateThreatening: Double
                
                /// The self-harm score
                public let selfHarm: Double
                
                /// The sexual content score
                public let sexual: Double
                
                /// The sexual content involving minors score
                public let sexualMinors: Double
                
                /// The violence score
                public let violence: Double
                
                /// The graphic violence score
                public let violenceGraphic: Double
                
                enum CodingKeys: String, CodingKey {
                    case hate
                    case hateThreatening = "hate/threatening"
                    case selfHarm = "self-harm"
                    case sexual
                    case sexualMinors = "sexual/minors"
                    case violence
                    case violenceGraphic = "violence/graphic"
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case flagged
                case categories
                case categoryScores = "category_scores"
            }
        }
    }
}