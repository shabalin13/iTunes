import UIKit

class ErrorView: UIView {
    
    // MARK: - Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: Constants.errorImageName))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .orange
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
        addSubview(errorLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),

            errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            errorLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -50),
        ])
    }
    
    // MARK: - Configuration
    func configure(error: String) {
        errorLabel.text = error
    }

}
