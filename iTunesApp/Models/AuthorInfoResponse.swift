import Foundation

struct AuthorInfoResponse: Decodable {
    
    let resultCount: Int
    let results: [AuthorInfo]
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
}
