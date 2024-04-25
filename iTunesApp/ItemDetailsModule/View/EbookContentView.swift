import UIKit

class EbookContentView: UIView {

    // MARK: - Properties
    weak var delegate: ContentViewDelegate?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ebookNameLabel: UILabel = {
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
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var ebookViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(ebookViewButtonTapped), for: .touchUpInside)
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
        addSubview(ebookNameLabel)
        addSubview(authorButton)
        addSubview(descriptionNameLabel)
        addSubview(descriptionLabel)
        addSubview(genresLabel)
        addSubview(ebookViewButton)
        addSubview(bottomInfoLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ebookNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        ebookViewButton.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            ebookNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            ebookNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            ebookNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            authorButton.topAnchor.constraint(equalTo: ebookNameLabel.bottomAnchor),
            authorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            authorButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            descriptionNameLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 15),
            descriptionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionNameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            ebookViewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            ebookViewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            genresLabel.topAnchor.constraint(equalTo: ebookViewButton.bottomAnchor, constant: 20),
            genresLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            genresLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            bottomInfoLabel.topAnchor.constraint(greaterThanOrEqualTo: genresLabel.bottomAnchor, constant: 30),
            bottomInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bottomInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            bottomInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Configuration
    func configure(itemDetails: DisplayedEbookItemDetails) {
        if let imageData = itemDetails.imageData {
            imageView.image = UIImage(data: imageData)
        }
        ebookNameLabel.text = itemDetails.ebookNameLabelText
        authorButton.setTitle(itemDetails.authorButtonText, for: .normal)
        if let descriptionLabelText = itemDetails.descriptionLabelText {
            descriptionNameLabel.isHidden = false
            descriptionLabel.text = descriptionLabelText.htmlToString
        } else {
            descriptionNameLabel.isHidden = true
        }
        if let genresLabelText = itemDetails.genresLabelText {
            genresLabel.isHidden = false
            genresLabel.text = genresLabelText
        } else {
            genresLabel.isHidden = true
        }
        ebookViewButton.isHidden = !itemDetails.isShowEbookViewButton
        bottomInfoLabel.text = itemDetails.bottomInfoLabelText
    }
    
    // MARK: - objc methods
    @objc private func authorButtonTapped() {
        delegate?.authorButtonTapped()
    }
    
    @objc private func ebookViewButtonTapped() {
        delegate?.mediaViewButtonTapped()
    }

}
