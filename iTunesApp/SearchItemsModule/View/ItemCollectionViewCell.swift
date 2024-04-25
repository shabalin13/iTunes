import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ItemCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return imageView
    }()
    
    private lazy var contentNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var explicitImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: Constants.explicitImageName))
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(imageView)
        contentView.addSubview(contentNameLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(explicitImageView)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        explicitImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            contentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            explicitImageView.heightAnchor.constraint(equalToConstant: 15),
            explicitImageView.widthAnchor.constraint(equalTo: explicitImageView.heightAnchor, multiplier: 1),
            explicitImageView.topAnchor.constraint(equalTo: contentNameLabel.topAnchor),
            explicitImageView.leadingAnchor.constraint(equalTo: contentNameLabel.trailingAnchor, constant: 5),
            explicitImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            
            secondaryLabel.topAnchor.constraint(equalTo: contentNameLabel.bottomAnchor, constant: 8),
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        contentNameLabel.text = nil
        secondaryLabel.text = nil
        descriptionLabel.text = nil
        explicitImageView.isHidden = true
        
    }
    
    func configureCell(item: DisplayedItem) {
        contentNameLabel.text = item.contentNameLabelText
        secondaryLabel.text = item.secondaryLabelText
        descriptionLabel.text = item.descriptionLabelText
        if let isExplicit = item.explicit, isExplicit {
            explicitImageView.isHidden = false
        } else {
            explicitImageView.isHidden = true
        }
    }
    
    func updateImage(image: UIImage) {
        self.imageView.image = image
    }
    
}
