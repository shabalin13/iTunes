struct Items: Decodable {
    
    let resultCount: Int
    let results: [Item]
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
}
