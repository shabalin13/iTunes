import Foundation

struct AuthorInfo: Decodable {
    
    let authorName: String?
    let authorLinkURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case authorName = "artistName"
        case authorLinkURL = "artistLinkUrl"
    }
    
}
