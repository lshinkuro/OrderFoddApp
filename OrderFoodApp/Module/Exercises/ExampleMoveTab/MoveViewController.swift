import UIKit
import SnapKit

// MARK: - Move Category Model
struct MoveCategory {
    let title: String
    let description: String
    let imageName: String
    let accentColor: UIColor
    let type: CategoryType
    
    enum CategoryType {
        case recent
        case recommended
    }
}

// MARK: - Custom TableView Cell
class MoveCategoryCell: UITableViewCell {
    static let identifier = "MoveCategoryCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let accentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(accentView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(categoryImageView.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(categoryImageView.snp.leading).offset(-8)
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
        
        accentView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    func configure(with category: MoveCategory) {
        titleLabel.text = category.title
        descriptionLabel.text = category.description
        categoryImageView.image = UIImage(named: category.imageName)
        accentView.backgroundColor = category.accentColor
    }
}

// MARK: - Custom Tab Button
class TabButton: UIButton {
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var isTabSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        setTitleColor(.systemGray, for: .normal)
        
        addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
        }
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        setTitleColor(isTabSelected ? .black : .systemGray, for: .normal)
        underlineView.isHidden = !isTabSelected
    }
}

// MARK: - Move View Controller
class MoveViewController: UIViewController {
    private var allCategories: [MoveCategory] = [
        // Recent Categories
        MoveCategory(title: "Feel-Good Yoga",
                    description: "Yoga classes for waking up, falling asleep, and every breath in between.",
                    imageName: "yoga_image",
                    accentColor: .systemYellow,
                    type: .recent),
        MoveCategory(title: "Morning Stretch",
                    description: "Start your day with energizing stretches.",
                    imageName: "stretch_image",
                    accentColor: .systemBlue,
                    type: .recent),
        
        // Recommended Categories
        MoveCategory(title: "Lincoln Center Dance Breaks",
                    description: "Get in the groove with dance moves from around the world.",
                    imageName: "dance_image",
                    accentColor: .systemOrange,
                    type: .recommended),
        MoveCategory(title: "HIIT Workout",
                    description: "High-intensity interval training for maximum results.",
                    imageName: "hiit_image",
                    accentColor: .systemRed,
                    type: .recommended)
    ]
    
    private var currentCategories: [MoveCategory] = []
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var recentButton: TabButton = {
        let button = TabButton()
        button.setTitle("Recent", for: .normal)
        button.isTabSelected = true
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var recommendedButton: TabButton = {
        let button = TabButton()
        button.setTitle("Recommended", for: .normal)
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Explore the library", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MoveCategoryCell.self, forCellReuseIdentifier: MoveCategoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContent(for: .recent) // Show recent content by default
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Move"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(backButtonTapped))
        
        tabStackView.addArrangedSubview(recentButton)
        tabStackView.addArrangedSubview(recommendedButton)
        
        view.addSubview(tabStackView)
        view.addSubview(exploreButton)
        view.addSubview(tableView)
        
        tabStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.top.equalTo(tabStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(exploreButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func updateContent(for type: MoveCategory.CategoryType) {
        currentCategories = allCategories.filter { $0.type == type }
        tableView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tabButtonTapped(_ sender: TabButton) {
        recentButton.isTabSelected = (sender == recentButton)
        recommendedButton.isTabSelected = (sender == recommendedButton)
        
        // Update content based on selected tab
        updateContent(for: sender == recentButton ? .recent : .recommended)
    }
}

// MARK: - UITableView Extensions
extension MoveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoveCategoryCell.identifier, for: indexPath) as? MoveCategoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: currentCategories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116 // Cell height + vertical padding
    }
}
