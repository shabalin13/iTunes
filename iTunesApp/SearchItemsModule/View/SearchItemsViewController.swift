import UIKit

protocol SearchItemsViewControllerProtocol: AnyObject {
    
    func startActivityIndicator()
    func stopActivityIndicator()
    func stopRefreshControl()
    func updateHistoryItems(historyItems: [HistoryItem])
    func updateSearchItems(items: [DisplayedItem])
    func showFiltersView(displayedParameters: [DisplayedParameter])
    func showErrorAlert(error: NetworkManagerError)
    func resetView()
    
}

class SearchItemsViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: SearchItemsPresenterProtocol
    
    private lazy var searchController: UISearchController = {
        let searchResultsController = SearchResultsViewController()
        searchResultsController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsController)
        return searchController
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var refreshControl = UIRefreshControl()
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, DisplayedItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, DisplayedItem>.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
            cell.configureCell(item: itemIdentifier)
            self.presenter.fetchItemImage(url: itemIdentifier.imageURL) { imageData in
                if let currentIndexPath = self.collectionView.indexPath(for: cell), currentIndexPath == indexPath, let image = UIImage(data: imageData) {
                    cell.updateImage(image: image)
                }
            }
            return cell
        })
        return dataSource
    }()
    
    // MARK: - Initializers
    init(presenter: SearchItemsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: - ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup view methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupActivityIndicator()
        setupRefreshControl()
        setupSearchController()
        setupNavigationBar()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.delegate = self
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "searchControllerPlaceholder".localize
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "searchControllerTitle".localize
        navigationItem.backButtonTitle = "backButtonTitle".localize
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.filtersImageName), style: .plain, target: self, action: #selector(goToFilters))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshSearchItems), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - CollectionView methods
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 5, leading: 15, bottom: 15, trailing: 10)
            section.interGroupSpacing = 10
            
            return section
        }
        return layout
    }
    
    // MARK: - DataSource methods
    private func createSnapshot(items: [DisplayedItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DisplayedItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Search method
    private func searchItems(term: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(searchDone))
        searchController.isActive = false
        presenter.searchItems(term: term)
        searchController.searchBar.text = term
    }
    
    private func enableView() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        view.isUserInteractionEnabled = true
        searchController.searchBar.isUserInteractionEnabled = true
    }
    
    private func disableView() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        view.isUserInteractionEnabled = false
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    // MARK: - objc methods
    @objc private func goToFilters() {
        presenter.getSearchItemsParameters()
    }
    
    @objc private func searchDone() {
        presenter.resetSearchItems()
    }
    
    @objc private func refreshSearchItems() {
        disableView()
        presenter.refreshSearchItems()
    }
    
}

// MARK: - SearchItemsViewControllerProtocol
extension SearchItemsViewController: SearchItemsViewControllerProtocol {
    
    func startActivityIndicator() {
        disableView()
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        enableView()
        activityIndicator.stopAnimating()
    }
    
    func stopRefreshControl() {
        enableView()
        refreshControl.endRefreshing()
    }
    
    func updateHistoryItems(historyItems: [HistoryItem]) {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.updateView(historyItems: historyItems)
        }
    }
    
    func updateSearchItems(items: [DisplayedItem]) {
        createSnapshot(items: items)
    }
    
    func showFiltersView(displayedParameters: [DisplayedParameter]) {
        let filtersViewController = SearchFiltersViewController(displayedParameters: displayedParameters)
        filtersViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: filtersViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: NetworkManagerError) {
        searchDone()
        let alertController = UIAlertController(title: "errorAlertTitle".localize, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localize, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func resetView() {
        searchController.searchBar.text = nil
        navigationItem.leftBarButtonItem = nil
    }
    
}

// MARK: - SearchResultsViewControllerDelegate
extension SearchItemsViewController: SearchResultsViewControllerDelegate {
    
    func didSelectHistoryItem(historyItem: HistoryItem) {
        searchItems(term: historyItem)
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchItemsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            presenter.getHistoryItems(term: searchController.searchBar.text)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchItems(term: term)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDone()
    }
    
}

// MARK: - UICollectionViewDelegate
extension SearchItemsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2, animations: {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            self.presenter.goToItemDetails(selectedItemIdx: indexPath.item)
            UIView.animate(withDuration: 0.2) {
                cell.alpha = 1.0
                cell.transform = .identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 1.0
            cell.transform = .identity
        }
    }
    
}

// MARK: - SearchFiltersViewControllerDelegate
extension SearchItemsViewController: SearchFiltersViewControllerDelegate {
    
    func didSelectFilters(selectedParametersIdxs: [Int]) {
        presenter.searchItems(selectedParametersIdxs: selectedParametersIdxs)
    }
    
}
