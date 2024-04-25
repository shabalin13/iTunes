import UIKit

class FilterView: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        let font = UIFont.systemFont(ofSize: 14)
        return segmentedControl
    }()
    
    // MARK: - Initializers    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(segmentedControl)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, allCases: [String], selected: String) {
        titleLabel.text = title
        for (idx, segmentTitle) in allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: segmentTitle, at: idx, animated: false)
            if segmentTitle == selected {
                segmentedControl.selectedSegmentIndex = idx
            }
        }
    }
    
    // MARK: - Methods
    func getSelectedIdx() -> Int {
        return segmentedControl.selectedSegmentIndex
    }
    
}
