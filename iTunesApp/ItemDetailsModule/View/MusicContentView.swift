import UIKit

class MusicContentView: UIView {
    
    // MARK: - Properties
    weak var delegate: ContentViewDelegate?
    private var albums: [DisplayedAlbum] = []
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return imageView
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(authorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    private lazy var trackViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(trackViewButtonTapped), for: .touchUpInside)
        button.setTitle("mediaButtonTitle".localize, for: .normal)
        return button
    }()
    
    private lazy var albumsNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "albumsTitle".localize
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        addSubview(trackNameLabel)
        addSubview(authorButton)
        addSubview(genreLabel)
        addSubview(trackViewButton)
        addSubview(albumsNameLabel)
        addSubview(collectionView)
        addSubview(bottomInfoLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        trackViewButton.translatesAutoresizingMaskIntoConstraints = false
        albumsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            
            trackNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            trackNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            authorButton.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor),
            authorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            authorButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            genreLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 2),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            trackViewButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            trackViewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            albumsNameLabel.topAnchor.constraint(equalTo: trackViewButton.bottomAnchor, constant: 15),
            albumsNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            albumsNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: albumsNameLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomInfoLabel.topAnchor.constraint(greaterThanOrEqualTo: collectionView.bottomAnchor, constant: 30),
            bottomInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bottomInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            bottomInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Configuration
    func configure(itemDetails: DisplayedMusicItemDetails, albums: [DisplayedAlbum]) {
        if let imageData = itemDetails.imageData {
            imageView.image = UIImage(data: imageData)
        }
        trackNameLabel.text = itemDetails.trackNameLabelText
        authorButton.setTitle(itemDetails.authorButtonText, for: .normal)
        if let genreLabelText = itemDetails.genreLabelText {
            genreLabel.isHidden = false
            genreLabel.text = genreLabelText
        } else {
            genreLabel.isHidden = false
        }
        trackViewButton.isHidden = !itemDetails.isShowTrackViewButton
        
        self.albums = albums
        if albums.isEmpty {
            albumsNameLabel.isHidden = true
            collectionView.isHidden = true
            NSLayoutConstraint.activate([
                collectionView.heightAnchor.constraint(equalToConstant: 0)
            ])
        } else {
            albumsNameLabel.isHidden = false
            collectionView.isHidden = false
            NSLayoutConstraint.activate([
                collectionView.heightAnchor.constraint(equalToConstant: 200)
            ])
            collectionView.reloadData()
        }
        
        bottomInfoLabel.text = itemDetails.bottomInfoLabelText
    }
    
    // MARK: - objc methods
    @objc private func authorButtonTapped() {
        delegate?.authorButtonTapped()
    }
    
    @objc private func trackViewButtonTapped() {
        delegate?.mediaViewButtonTapped()
    }
    
}

extension MusicContentView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        let album = albums[indexPath.item]
        cell.configureCell(album: album)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }

}
