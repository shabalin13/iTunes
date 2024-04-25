import Foundation

struct Item {
    
    let wrapperType: String?
    let kind: String?
    
    let artistId: Int?
    let artistName: String?
    let artistViewURL: URL?
    
    let trackId: Int?
    let trackName: String?
    let trackViewURL: URL?
    
    let artworkURL: URL?
    
    let primaryGenreName: String?
    
    let trackExplicitness: Bool?
    
    let releaseDate: Date?
    
    let contentAdvisoryRating: String?
    let longDescription: String?
    let collectionArtistId: Int?
    
    let trackTime: Int?
    
    let description: String?
    let genres: [String]?
    let fileSize: Int?
    let userRatingCount: Int?
    let averageUserRating: Double?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistId, artistName, artistViewURL = "artistViewUrl"
        case trackId, trackName, trackViewURL = "trackViewUrl"
        case artworkURL = "artworkUrl100"
        case primaryGenreName
        case trackExplicitness
        case releaseDate, contentAdvisoryRating, longDescription, collectionArtistId
        case trackTime = "trackTimeMillis"
        case description, genres, fileSize = "fileSizeBytes", userRatingCount, averageUserRating
    }
    
}

extension Item: Decodable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        wrapperType = try container.decodeIfPresent(String.self, forKey: .wrapperType)
        kind = try container.decodeIfPresent(String.self, forKey: .kind)
        artistId = try container.decodeIfPresent(Int.self, forKey: .artistId)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        artistViewURL = try container.decodeIfPresent(URL.self, forKey: .artistViewURL)
        trackId = try container.decodeIfPresent(Int.self, forKey: .trackId)
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
        trackViewURL = try container.decodeIfPresent(URL.self, forKey: .trackViewURL)
        artworkURL = try container.decodeIfPresent(URL.self, forKey: .artworkURL)
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName)
        
        if let explicitnessString = try container.decodeIfPresent(String.self, forKey: .trackExplicitness) {
            trackExplicitness = explicitnessString != "notExplicit"
        } else {
            trackExplicitness = nil
        }
        
        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        if let dateString = dateString {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime]
            releaseDate = dateFormatter.date(from: dateString)
        } else {
            releaseDate = nil
        }
        
        contentAdvisoryRating = try container.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription)
        collectionArtistId = try container.decodeIfPresent(Int.self, forKey: .collectionArtistId)
        
        trackTime = try container.decodeIfPresent(Int.self, forKey: .trackTime)

        description = try container.decodeIfPresent(String.self, forKey: .description)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        fileSize = try container.decodeIfPresent(Int.self, forKey: .fileSize)
        userRatingCount = try container.decodeIfPresent(Int.self, forKey: .userRatingCount)
        averageUserRating = try container.decodeIfPresent(Double.self, forKey: .averageUserRating)
                
    }
}
