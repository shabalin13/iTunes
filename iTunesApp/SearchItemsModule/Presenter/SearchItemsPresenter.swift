import Dispatch
import Foundation

protocol SearchItemsPresenterProtocol {
    
    func searchItems(term: String)
    func searchItems(selectedParametersIdxs: [Int])
    func fetchItemImage(url: URL?, completionHandler: @escaping (Data) -> Void)
    func refreshSearchItems()
    func resetSearchItems()
    func getHistoryItems(term: String?)
    func getSearchItemsParameters()
    func goToItemDetails(selectedItemIdx: Int)
    
}

final class SearchItemsPresenter {
    
    // MARK: - Properties
    weak private var coordinator: SearchItemsCoordinatorProtocol?
    weak private var view: SearchItemsViewControllerProtocol?
    private let networkManager: NetworkManagerProtocol
    
    private var currentSearchItemsParameters = SearchItemsParameters()
    private var currentItems: Items?
    
    // MARK: - Initializers
    init(coordinator: SearchItemsCoordinatorProtocol) {
        self.coordinator = coordinator
        self.networkManager = NetworkManager()
    }
    
    // MARK: - Methods
    func setView(view: SearchItemsViewControllerProtocol) {
        self.view = view
    }
    
    private func saveTerm(term: String) {
        var allHistoryItems = UserDefaults.standard.stringArray(forKey: Constants.historyItemKey) ?? []
        if let idx = allHistoryItems.firstIndex(of: term) {
            allHistoryItems.remove(at: idx)
        }
        allHistoryItems.append(term)
        UserDefaults.standard.set(allHistoryItems, forKey: Constants.historyItemKey)
    }
    
    private func prepareItems(items: [Item]) -> [DisplayedItem] {
        var displayedItems = [DisplayedItem]()
        for item in items {
            let secondaryLabelText: String
            let descriptionLabelText: String
            let explicit: Bool?
            switch currentSearchItemsParameters.mediaType {
            case .music:
                secondaryLabelText = item.artistName ?? "Unknown".localize
                if let trackTime = item.trackTime {
                    descriptionLabelText = "\(MediaType.music.rawValue.capitalized.localize) • \(getTimeString(milliseconds: trackTime))"
                } else {
                    descriptionLabelText = "\(MediaType.music.rawValue.capitalized.localize)"
                }
                explicit = item.trackExplicitness ?? false
            case .movie:
                if let genre = item.primaryGenreName {
                    secondaryLabelText = "\(MediaType.movie.rawValue.capitalized.localize) • \(genre)"
                } else {
                    secondaryLabelText = "\(MediaType.movie.rawValue.capitalized.localize)"
                }
                if let releaseDate = item.releaseDate {
                    descriptionLabelText = "\(getDateString(date: releaseDate))"
                } else {
                    descriptionLabelText = ""
                }
                explicit = nil
            case .ebook:
                secondaryLabelText = item.artistName ?? "Unknown".localize
                if let userRatingCount = item.userRatingCount, let averageUserRating = item.averageUserRating {
                    descriptionLabelText = "\(MediaType.ebook.rawValue.capitalized.localize) • ★ \(averageUserRating) (\(userRatingCount))"
                } else {
                    descriptionLabelText = "\(MediaType.ebook.rawValue.capitalized.localize)"
                }
                explicit = nil
            }
            displayedItems.append(DisplayedItem(contentNameLabelText: item.trackName ?? "Unknown".localize, secondaryLabelText: secondaryLabelText, descriptionLabelText: descriptionLabelText, explicit: explicit, imageURL: item.artworkURL))
        }
        return displayedItems
    }
    
    private func getTimeString(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dateFormat".localize
        return dateFormatter.string(from: date)
    }
    
}

// MARK: - SearchItemsPresenterProtocol
extension SearchItemsPresenter: SearchItemsPresenterProtocol {
    
    func searchItems(term: String) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        DispatchQueue.global().async {
            self.saveTerm(term: term)
            self.currentSearchItemsParameters.term = term
            self.networkManager.searchItems(searchItemsParameters: self.currentSearchItemsParameters) { result in
                switch result {
                case .success(let items):
                    self.currentItems = items
                    let displayedItems = self.prepareItems(items: items.results)
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.updateSearchItems(items: displayedItems)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.showErrorAlert(error: error)
                    }
                }
            }
        }
    }
    
    func searchItems(selectedParametersIdxs: [Int]) {
        if selectedParametersIdxs.count == 4 {
            if let mediaType = MediaType.fromIdx(idx: selectedParametersIdxs[0]) {
                currentSearchItemsParameters.mediaType = mediaType
            }
            if let explicit = Explicit.fromIdx(idx: selectedParametersIdxs[1]) {
                currentSearchItemsParameters.explicit = explicit
            }
            if let country = Country.fromIdx(idx: selectedParametersIdxs[2]) {
                currentSearchItemsParameters.country = country
            }
            if let limit = Limit.fromIdx(idx: selectedParametersIdxs[3]) {
                currentSearchItemsParameters.limit = limit
            }
        }
        if currentSearchItemsParameters.term != "" {
            DispatchQueue.main.async {
                self.view?.startActivityIndicator()
            }
            DispatchQueue.global().async {
                self.networkManager.searchItems(searchItemsParameters: self.currentSearchItemsParameters) { result in
                    switch result {
                    case .success(let items):
                        self.currentItems = items
                        let displayedItems = self.prepareItems(items: items.results)
                        DispatchQueue.main.async {
                            self.view?.stopActivityIndicator()
                            self.view?.updateSearchItems(items: displayedItems)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.view?.stopActivityIndicator()
                            self.view?.showErrorAlert(error: error)
                        }
                    }
                }
            }
        }
    }
    
    func fetchItemImage(url: URL?, completionHandler: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            if let url = url {
                self.networkManager.fetchItemImage(url: url) { result in
                    if case .success(let imageData) = result {
                        DispatchQueue.main.async {
                            completionHandler(imageData)
                        }
                    }
                }
            }
        }
    }
    
    func refreshSearchItems() {
        if currentSearchItemsParameters.term != "" {
            DispatchQueue.global().async {
                self.networkManager.searchItems(searchItemsParameters: self.currentSearchItemsParameters) { result in
                    switch result {
                    case .success(let items):
                        self.currentItems = items
                        let displayedItems = self.prepareItems(items: items.results)
                        DispatchQueue.main.async {
                            self.view?.stopRefreshControl()
                            self.view?.updateSearchItems(items: displayedItems)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.view?.stopRefreshControl()
                            self.view?.showErrorAlert(error: error)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.view?.stopRefreshControl()
            }
        }
    }
    
    func resetSearchItems() {
        currentSearchItemsParameters = SearchItemsParameters()
        currentItems = nil
        view?.updateSearchItems(items: [])
        view?.resetView()
    }
    
    func getHistoryItems(term: String?) {
        guard let term = term else {
            self.view?.updateHistoryItems(historyItems: [])
            return
        }
        let allHistoryItems = UserDefaults.standard.stringArray(forKey: Constants.historyItemKey) ?? []
        let historyItems: [HistoryItem]
        if term == "" {
            historyItems = Array<HistoryItem>(allHistoryItems.suffix(5).reversed())
        } else {
            historyItems = Array<HistoryItem>(allHistoryItems.filter { $0.lowercased().contains(term.lowercased()) }.suffix(5).reversed())
        }
        self.view?.updateHistoryItems(historyItems: historyItems)
    }
    
    func getSearchItemsParameters() {
        let displayedParameters: [DisplayedParameter] = [
            DisplayedParameter(title: "filtersMediaTypeTitle".localize, allCases: MediaType.allCases.map({ $0.rawValue.capitalized.localize }), selected: currentSearchItemsParameters.mediaType.rawValue.capitalized.localize),
            DisplayedParameter(title: "filtersExplicitTitle".localize, allCases: Explicit.allCases.map({ $0.rawValue.capitalized.localize }), selected: currentSearchItemsParameters.explicit.rawValue.capitalized.localize),
            DisplayedParameter(title: "filtersCountryTitle".localize, allCases: Country.allCases.map({ $0.rawValue }), selected: currentSearchItemsParameters.country.rawValue),
            DisplayedParameter(title: "filtersLimitTitle".localize, allCases: Limit.allCases.map( { $0.rawValue }), selected: currentSearchItemsParameters.limit.rawValue),
        ]
        self.view?.showFiltersView(displayedParameters: displayedParameters)
    }
    
    func goToItemDetails(selectedItemIdx: Int) {
        guard let currentItems = currentItems else { return }
        coordinator?.goToItemDetails(selectedMediaType: currentSearchItemsParameters.mediaType, selectedItem: currentItems.results[selectedItemIdx])
    }
    
}
