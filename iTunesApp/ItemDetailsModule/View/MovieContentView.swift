import UIKit

class MovieContentView: UIView {

    // MARK: - Properties
    weak var delegate: ContentViewDelegate?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    private lazy var descriptionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "descriptionTitle".localize
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var movieViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(movieViewButtonTapped), for: .touchUpInside)
        button.setTitle("mediaButtonTitle".localize, for: .normal)
        return button
    }()
    
    private lazy var bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
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
        addSubview(movieNameLabel)
        addSubview(authorButton)
        addSubview(descriptionNameLabel)
        addSubview(descriptionLabel)
        addSubview(movieViewButton)
        addSubview(bottomInfoLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        movieViewButton.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            movieNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            movieNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            authorButton.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor),
            authorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            authorButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            descriptionNameLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 15),
            descriptionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionNameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            movieViewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            movieViewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomInfoLabel.topAnchor.constraint(greaterThanOrEqualTo: movieViewButton.bottomAnchor, constant: 20),
            bottomInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bottomInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            bottomInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Configuration
    func configure(itemDetails: DisplayedMovieItemDetails) {
        if let imageData = itemDetails.imageData {
            imageView.image = UIImage(data: imageData)
        }
        movieNameLabel.text = itemDetails.movieNameLabelText
        authorButton.setTitle(itemDetails.authorButtonText, for: .normal)
        if let descriptionLabelText = itemDetails.descriptionLabelText {
            descriptionNameLabel.isHidden = false
            descriptionLabel.text = descriptionLabelText
        } else {
            descriptionNameLabel.isHidden = true
        }
        movieViewButton.isHidden = !itemDetails.isShowMovieViewButton
        bottomInfoLabel.text = itemDetails.bottomInfoLabelText
    }
    
    // MARK: - objc methods
    @objc private func authorButtonTapped() {
        delegate?.authorButtonTapped()
    }
    
    @objc private func movieViewButtonTapped() {
        delegate?.mediaViewButtonTapped()
    }

}
