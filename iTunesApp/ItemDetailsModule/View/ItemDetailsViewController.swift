import UIKit

protocol ContentViewDelegate: AnyObject {
    
    func authorButtonTapped()
    func mediaViewButtonTapped()
    
}

protocol ItemDetailsViewControllerProtocol: AnyObject {
    
    func startActivityIndicator()
    func stopActivityIndicator()
    func updateView(title: String, itemDetails: DisplayedMusicItemDetails, albums: [DisplayedAlbum])
    func updateView(title: String, itemDetails: DisplayedMovieItemDetails)
    func updateView(title: String, itemDetails: DisplayedEbookItemDetails)
    func showErrorView(title: String, error: String)
    func openHyperLink(url: URL)
    
}

class ItemDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: ItemDetailsPresenterProtocol
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var musicContentView = MusicContentView()
    private lazy var movieContentView = MovieContentView()
    private lazy var ebookContentView = EbookContentView()
    private lazy var errorView = ErrorView()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializers
    init(presenter: ItemDetailsPresenterProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getItemDetails()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.backToSearchItems()
    }
    
    // MARK: - Setup view methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupActivityIndicator()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
                
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    
}

// MARK: - ItemDetailsViewControllerProtocol
extension ItemDetailsViewController: ItemDetailsViewControllerProtocol {
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func updateView(title: String, itemDetails: DisplayedMusicItemDetails, albums: [DisplayedAlbum]) {
        navigationItem.title = title
        
        if itemDetails.isShowExplitic {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.explicitImageName), style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .gray
        }

        musicContentView.configure(itemDetails: itemDetails, albums: albums)
        musicContentView.delegate = self
        scrollView.addSubview(musicContentView)
        musicContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            musicContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            musicContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            musicContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            musicContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            musicContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            musicContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, multiplier: 1)
        ])
    }
    
    func updateView(title: String, itemDetails: DisplayedMovieItemDetails) {
        navigationItem.title = title
        movieContentView.configure(itemDetails: itemDetails)
        movieContentView.delegate = self
        scrollView.addSubview(movieContentView)
        movieContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            movieContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            movieContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            movieContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            movieContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            movieContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, multiplier: 1)
        ])
    }
    
    func updateView(title: String, itemDetails: DisplayedEbookItemDetails) {
        navigationItem.title = title
        ebookContentView.configure(itemDetails: itemDetails)
        ebookContentView.delegate = self
        scrollView.addSubview(ebookContentView)
        ebookContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ebookContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            ebookContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            ebookContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            ebookContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ebookContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ebookContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, multiplier: 1)
        ])
    }
    
    func showErrorView(title: String, error: String) {
        navigationItem.title = title
        errorView.configure(error: error)
        scrollView.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            errorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            errorView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, multiplier: 1)
        ])
    }
    
    func openHyperLink(url: URL) {
        UIApplication.shared.open(url)
    }
    
}

extension ItemDetailsViewController: ContentViewDelegate {
    
    func authorButtonTapped() {
        presenter.goToAuthorLink()
    }
    
    func mediaViewButtonTapped() {
        presenter.goToMediaLink()
    }
    
}
