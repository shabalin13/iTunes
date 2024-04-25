enum MediaType: String, CaseIterable {
    
    case music
    case movie
    case ebook
    
    var entity: String {
        switch self {
        case .music:
            return "song"
        case .movie:
            return "movie"
        case .ebook:
            return "ebook"
        }
    }
    
    static func fromIdx(idx: Int) -> MediaType? {
        let allCases = self.allCases
        guard idx >= 0 && idx < allCases.count else {
            return nil
        }
        return allCases[idx]
    }
    
}
