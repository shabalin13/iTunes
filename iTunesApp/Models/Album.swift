import Foundation

struct Album: Decodable {
    
    let artistName: String?
    let collectionName: String?
    let artworkURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, artworkURL = "artworkUrl100"
    }
    
}
