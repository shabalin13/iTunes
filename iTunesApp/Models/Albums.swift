import Foundation

struct Albums: Decodable {
    
    let resultCount: Int
    let results: [Album]
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
}
