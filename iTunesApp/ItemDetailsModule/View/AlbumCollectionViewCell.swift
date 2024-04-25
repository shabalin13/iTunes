import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AlbumCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return imageView
    }()
    
    private lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        addSubview(albumLabel)
        addSubview(authorLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            albumLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            albumLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            authorLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            authorLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        albumLabel.text = nil
        authorLabel.text = nil
    }
    
    func configureCell(album: DisplayedAlbum) {
        imageView.image = UIImage(data: album.imageData)
        albumLabel.text = album.albumLabelText
        authorLabel.text = album.authorLabelText
    }
}

