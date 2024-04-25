import Foundation
import Dispatch

protocol ItemDetailsPresenterProtocol {
    
    func getItemDetails()
    func goToAuthorLink()
    func goToMediaLink()
    func backToSearchItems()
    
}

final class ItemDetailsPresenter {
    
    // MARK: - Properties
    weak private var coordinator: ItemDetailsCoordinatorProtocol?
    weak private var view: ItemDetailsViewControllerProtocol?
    
    private let networkManager: NetworkManagerProtocol
    private let currentItem: Item
    private let currentMediaType: MediaType
    
    private var authorInfo: AuthorInfo?
    private var imageData: Data?
    private var albums: Albums?
    
    // MARK: - Initializers
    init(coordinator: ItemDetailsCoordinatorProtocol, selectedMediaType: MediaType, selectedItem: Item) {
        self.coordinator = coordinator
        self.currentMediaType = selectedMediaType
        self.currentItem = selectedItem
        self.networkManager = NetworkManager()
    }
    
    // MARK: - Methods
    func setView(view: ItemDetailsViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Networking
    private func fetchItemImage(url: URL, group: DispatchGroup) {
        DispatchQueue.global().async {
            self.networkManager.fetchItemImage(url: url) { result in
                switch result {
                case .success(let imageData):
                    self.imageData = imageData
                case .failure(_):
                    self.imageData = nil
                }
                group.leave()
            }
        }
    }
    
    private func getAuthorInfo(id: Int, group: DispatchGroup) {
        DispatchQueue.global().async {
            self.networkManager.lookupById(id: id) { result in
                switch result {
                case .success(let authorInfoResponse):
                    if let authorInfo = authorInfoResponse.results.first {
                        self.authorInfo = authorInfo
                    }
                case .failure(_):
                    self.authorInfo = nil
                }
                group.leave()
            }
        }
    }
    
    private func getAlbums(id: Int, group: DispatchGroup) {
        DispatchQueue.global().async {
            self.networkManager.getAlbums(id: id, limit: 5) { result in
                switch result {
                case .success(let albums):
                    self.albums = albums
                case .failure(_):
                    self.albums = nil
                }
                group.leave()
            }
        }
    }
    
    private func fetchAlbumImage(url: URL, completionHandler: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            self.networkManager.fetchItemImage(url: url) { result in
                switch result {
                case .success(let imageData):
                    completionHandler(imageData)
                case .failure(_):
                    completionHandler(nil)
                }
            }
        }
    }
    
    // MAKR: - Data preparation
    private func prepareMusicItemDetails(imageData: Data?, authorName: String) -> DisplayedMusicItemDetails {
        let trackNameLabelText = self.currentItem.trackName ?? "Unknown".localize
        let authorButtonText = authorName
        let genreLabelText = self.currentItem.primaryGenreName
        let isShowTrackViewButton = self.currentItem.trackViewURL != nil
        var bottomInfoLabelText = ""
        if let releaseDate = self.currentItem.releaseDate {
            bottomInfoLabelText += "\(self.getDateString(date: releaseDate))\n"
        }
        if let trackTime = self.currentItem.trackTime, let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type) • \(self.getMusicTimeString(milliseconds: trackTime))"
        } else if let trackTime = self.currentItem.trackTime {
            bottomInfoLabelText += "\(self.getMusicTimeString(milliseconds: trackTime))"
        } else if let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type)"
        } else {
            bottomInfoLabelText += "\(self.currentMediaType.entity.localize)"
        }
        let isShowExplitic = self.currentItem.trackExplicitness ?? false
        
        let musicItemDetails = DisplayedMusicItemDetails(imageData: imageData, trackNameLabelText: trackNameLabelText, authorButtonText: authorButtonText, genreLabelText: genreLabelText, isShowTrackViewButton: isShowTrackViewButton, bottomInfoLabelText: bottomInfoLabelText, isShowExplitic: isShowExplitic)
        return musicItemDetails
    }
    
    private func prepareEbookItemDetails(imageData: Data?, authorName: String) -> DisplayedEbookItemDetails {
        let ebookNameLabelText = self.currentItem.trackName ?? "Unknown".localize
        let authorButtonText = authorName
        let descriptionLabelText = self.currentItem.description
        let genresLabelText = concatGenres(genres: self.currentItem.genres)
        let isShowEbookViewButton = self.currentItem.trackViewURL != nil
        var bottomInfoLabelText = ""
        if let userRatingCount = self.currentItem.userRatingCount, let averageUserRating = self.currentItem.averageUserRating {
            bottomInfoLabelText += "★ \(averageUserRating) (\(userRatingCount))\n"
        }
        if let releaseDate = self.currentItem.releaseDate {
            bottomInfoLabelText += "\(self.getDateString(date: releaseDate))\n"
        }
        if let fileSize = self.currentItem.fileSize, let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type) • \(self.fileSizeString(fileSizeBytes: fileSize))"
        } else if let fileSize = self.currentItem.fileSize {
            bottomInfoLabelText += "\(self.fileSizeString(fileSizeBytes: fileSize))"
        } else if let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type)"
        } else {
            bottomInfoLabelText += "\(self.currentMediaType.entity.localize)"
        }
        
        let ebookItemDetails = DisplayedEbookItemDetails(imageData: imageData, ebookNameLabelText: ebookNameLabelText, authorButtonText: authorButtonText, descriptionLabelText: descriptionLabelText, genresLabelText: genresLabelText, isShowEbookViewButton: isShowEbookViewButton, bottomInfoLabelText: bottomInfoLabelText)
        return ebookItemDetails
    }
    
    private func prepareMovieItemDetails(imageData: Data?, authorName: String) -> DisplayedMovieItemDetails {
        let movieNameLabelText = self.currentItem.trackName ?? "Unknown".localize
        let authorButtonText = authorName
        let descriptionLabelText = self.currentItem.longDescription
        let isShowMovieViewButton = self.currentItem.trackViewURL != nil
        var bottomInfoLabelText = ""
        if let releaseDate = self.currentItem.releaseDate {
            bottomInfoLabelText += "\(self.getDateString(date: releaseDate))\n"
        }
        
        if let genre = self.currentItem.primaryGenreName, let contentAdvisoryRating = self.currentItem.contentAdvisoryRating {
            bottomInfoLabelText += "\(genre) • \(contentAdvisoryRating)\n"
        } else if let genre = self.currentItem.primaryGenreName {
            bottomInfoLabelText += "\(genre)\n"
        } else if let contentAdvisoryRating = self.currentItem.contentAdvisoryRating {
            bottomInfoLabelText += "\(contentAdvisoryRating)\n"
        }
        
        if let trackTime = self.currentItem.trackTime, let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type) • \(self.getMovieTimeString(milliseconds: trackTime))"
        } else if let trackTime = self.currentItem.trackTime {
            bottomInfoLabelText += "\(self.getMovieTimeString(milliseconds: trackTime))"
        } else if let type = self.currentItem.kind {
            bottomInfoLabelText += "\(type)"
        } else {
            bottomInfoLabelText += "\(self.currentMediaType.entity.localize)"
        }
        
        let movieItemDetails = DisplayedMovieItemDetails(imageData: imageData, movieNameLabelText: movieNameLabelText, authorButtonText: authorButtonText, descriptionLabelText: descriptionLabelText, isShowMovieViewButton: isShowMovieViewButton, bottomInfoLabelText: bottomInfoLabelText)
        return movieItemDetails
    }
    
    // MARK: - Helper methods
    private func concatGenres(genres: [String]?) -> String? {
        guard let genres = genres, !genres.isEmpty else { return nil}
        if genres.count == 1 { return genres[0] }
        
        var result = ""
        for (idx, element) in genres.enumerated() {
            result += element
            if idx < genres.count - 1 {
                result += ", "
            }
        }
        return result
    }
    
    private func fileSizeString(fileSizeBytes: Int) -> String {
        let fileSizeInMegabytes = Double(fileSizeBytes) / (1024 * 1024)
        let formattedSize = String(format: "%.2f", fileSizeInMegabytes)
        return "\(formattedSize) MB"
    }
    
    private func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dateFormat".localize
        return dateFormatter.string(from: date)
    }
    
    private func getMusicTimeString(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getMovieTimeString(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

// MARK: - ItemDetailsPresenterProtocol
extension ItemDetailsPresenter: ItemDetailsPresenterProtocol {
    
    func getItemDetails() {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        let group = DispatchGroup()
        
        switch currentMediaType {
        case .music:
            if let id = currentItem.artistId {
                group.enter()
                getAuthorInfo(id: id, group: group)
                group.enter()
                getAlbums(id: id, group: group)
            }
        case .movie:
            if let id = currentItem.collectionArtistId {
                group.enter()
                getAuthorInfo(id: id, group: group)
            }
        case .ebook:
            if let id = currentItem.artistId {
                group.enter()
                getAuthorInfo(id: id, group: group)
            }
        }
        if let url = currentItem.artworkURL {
            group.enter()
            fetchItemImage(url: url, group: group)
        }
        
        group.notify(queue: .global()) {
            switch self.currentMediaType {
            case .music:
                if let albums = self.albums?.results, albums.count > 1 {
                    let imageGroup = DispatchGroup()
                    var displayedAlbums = [DisplayedAlbum]()
                    for album in albums {
                        if let artistName = album.artistName, let collectionName = album.collectionName, let artworkURL = album.artworkURL {
                            imageGroup.enter()
                            self.fetchAlbumImage(url: artworkURL) { imageData in
                                if let imageData = imageData {
                                    displayedAlbums.append(DisplayedAlbum(imageData: imageData, albumLabelText: collectionName, authorLabelText: artistName))
                                }
                                imageGroup.leave()
                            }
                        }
                    }
                    imageGroup.notify(queue: .global()) {
                        if let imageData = self.imageData, let authorName = self.authorInfo?.authorName {
                            let musicItemDetails = self.prepareMusicItemDetails(imageData: imageData, authorName: authorName)
                            DispatchQueue.main.async {
                                self.view?.stopActivityIndicator()
                                self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: musicItemDetails, albums: displayedAlbums)
                            }
                        } else if let authorName = self.authorInfo?.authorName {
                            let musicItemDetails = self.prepareMusicItemDetails(imageData: nil, authorName: authorName)
                            DispatchQueue.main.async {
                                self.view?.stopActivityIndicator()
                                self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: musicItemDetails, albums: displayedAlbums)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.view?.stopActivityIndicator()
                                self.view?.showErrorView(title: "errorTitle".localize, error: "lookupError".localize)
                            }
                        }
                    }
                } else {
                    if let imageData = self.imageData, let authorName = self.authorInfo?.authorName {
                        let musicItemDetails = self.prepareMusicItemDetails(imageData: imageData, authorName: authorName)
                        DispatchQueue.main.async {
                            self.view?.stopActivityIndicator()
                            self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: musicItemDetails, albums: [])
                        }
                    } else if let authorName = self.authorInfo?.authorName {
                        let musicItemDetails = self.prepareMusicItemDetails(imageData: nil, authorName: authorName)
                        DispatchQueue.main.async {
                            self.view?.stopActivityIndicator()
                            self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: musicItemDetails, albums: [])
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view?.stopActivityIndicator()
                            self.view?.showErrorView(title: "errorTitle".localize, error: "lookupError".localize)
                        }
                    }
                }
            case .ebook:
                if let imageData = self.imageData, let authorName = self.authorInfo?.authorName {
                    let ebookItemDetails = self.prepareEbookItemDetails(imageData: imageData, authorName: authorName)
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: ebookItemDetails)
                    }
                } else if let authorName = self.authorInfo?.authorName {
                    let ebookItemDetails = self.prepareEbookItemDetails(imageData: nil, authorName: authorName)
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: ebookItemDetails)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.showErrorView(title: "errorTitle".localize, error: "lookupError".localize)
                    }
                }
            case .movie:
                if let imageData = self.imageData, let authorName = self.authorInfo?.authorName {
                    let movieItemDetails = self.prepareMovieItemDetails(imageData: imageData, authorName: authorName)
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: movieItemDetails)
                    }
                } else if let authorName = self.authorInfo?.authorName {
                    let movieItemDetails = self.prepareMovieItemDetails(imageData: nil, authorName: authorName)
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.updateView(title: self.currentMediaType.rawValue.capitalized.localize, itemDetails: movieItemDetails)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.showErrorView(title: "errorTitle".localize, error: "lookupError".localize)
                    }
                }
            }
        }
        
    }
    
    func goToAuthorLink() {
        guard let url = authorInfo?.authorLinkURL else { return }
        DispatchQueue.main.async {
            self.view?.openHyperLink(url: url)
        }
    }
    
    func goToMediaLink() {
        guard let url = currentItem.trackViewURL else { return }
        DispatchQueue.main.async {
            self.view?.openHyperLink(url: url)
        }
    }
    
    func backToSearchItems() {
        coordinator?.backToSearchItems()
    }
    
}
