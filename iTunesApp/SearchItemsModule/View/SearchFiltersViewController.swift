import UIKit

protocol SearchFiltersViewControllerDelegate: AnyObject {
    
    func didSelectFilters(selectedParametersIdxs: [Int])
    
}

class SearchFiltersViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SearchFiltersViewControllerDelegate?
    private let displayedParameters: [DisplayedParameter]
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("filtersApplyButtonTitle".localize, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(applyFiltersTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(applyFiltersTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(applyFiltersTouchCancel), for: .touchCancel)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // MARK: - Initializers
    init(displayedParameters: [DisplayedParameter]) {
        self.displayedParameters = displayedParameters
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: - ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "filtersControllerTitle".localize
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        setupView()
        configureView()
    }
    
    // MARK: - Methods
    private func setupView() {
        
        view.addSubview(stackView)
        view.addSubview(applyButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: applyButton.topAnchor, constant: -30),
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func configureView() {
        for displayedParameter in displayedParameters {
            let filterView = FilterView()
            filterView.configure(title: displayedParameter.title, allCases: displayedParameter.allCases, selected: displayedParameter.selected)
            stackView.addArrangedSubview(filterView)
        }
    }
    
    // MARK: - objc methods
    @objc private func applyFiltersTouchDown() {
        UIView.animate(withDuration: 0.2) {
            self.applyButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
            self.applyButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func applyFiltersTouchCancel() {
        UIView.animate(withDuration: 0.2) {
            self.applyButton.backgroundColor = .systemBlue
            self.applyButton.transform = .identity
        }
    }
    
    @objc private func applyFiltersTouchUpInside() {
        UIView.animate(withDuration: 0.2) {
            self.applyButton.backgroundColor = .systemBlue
            self.applyButton.transform = .identity
        }
        
        var selectedParametersIdxs = [Int]()
        for view in stackView.arrangedSubviews {
            if let filterView = view as? FilterView {
                selectedParametersIdxs.append(filterView.getSelectedIdx())
            }
        }

        dismiss(animated: true) {
            self.delegate?.didSelectFilters(selectedParametersIdxs: selectedParametersIdxs)
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
