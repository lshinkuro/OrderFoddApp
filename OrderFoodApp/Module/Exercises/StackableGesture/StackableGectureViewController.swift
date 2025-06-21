import Foundation
import UIKit
import SnapKit

class StackableGectureViewController: UIViewController {
    
    // MARK: - Properties
    private let tabSegmentControl = UISegmentedControl(items: ["Entertainment", "Commerce"])
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var currentTab = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure Tab Control
        tabSegmentControl.selectedSegmentIndex = 0
        tabSegmentControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        
        // Custom appearance for tab control
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tabSegmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        tabSegmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        // Add bottom line for selected tab
        tabSegmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        tabSegmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        // Add views to hierarchy
        view.addSubview(tabSegmentControl)
        view.addSubview(tableView)
        
        // Setup constraints
        tabSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabSegmentControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - TableView Configuration
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StackableCardsCell.self, forCellReuseIdentifier: "StackableCardsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    // MARK: - Actions
    @objc private func tabChanged(_ sender: UISegmentedControl) {
        currentTab = sender.selectedSegmentIndex
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension StackableGectureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Section for stacking cards and another for other content
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5 // 1 row for stacking cards, 5 for other content
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StackableCardsCell", for: indexPath) as! StackableCardsCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Content Item \(indexPath.row + 1)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 350 : 60
    }
}

// MARK: - StackableCardsCell
class StackableCardsCell: UITableViewCell {
    
    // MARK: - Properties
    private var cardViews: [CardSwipeableView] = []
    private let stackContainer = UIView()
    private let pageControl = UIPageControl()
    
    // Mock data for the cards
    private let cardData = [
        (title: "Kode Redeem ML 11 Maret 2025 Edisi Ramadan", color: UIColor.systemPurple.withAlphaComponent(0.3)),
        (title: "Promo Game Terbaru", color: UIColor.systemBlue.withAlphaComponent(0.3)),
        (title: "Turnamen Mobile Legends", color: UIColor.systemGreen.withAlphaComponent(0.3)),
        (title: "Diskon Skin Limited Edition", color: UIColor.systemOrange.withAlphaComponent(0.3))
    ]
    
    private var currentIndex = 0
    private var initialCenter: CGPoint?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCards()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        
        // Configure page control
        pageControl.numberOfPages = cardData.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray
        
        // Add views to hierarchy
        contentView.addSubview(stackContainer)
        contentView.addSubview(pageControl)
        
        // Setup constraints
        stackContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Cards Setup
    private func setupCards() {
        // Remove any existing cards
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()

        // Create card views in reverse order (so the first one is on top)
        for i in (0..<cardData.count).reversed() {
            let cardView = CardSwipeableView()
            cardView.configure(with: cardData[i].title, backgroundColor: cardData[i].color)
            stackContainer.addSubview(cardView)
            cardViews.append(cardView)

            // Layout all cards with the same position initially
            cardView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-20) // Slightly higher than center
                make.width.equalToSuperview().multipliedBy(0.6)
                make.height.equalTo(280) // Fixed height for all cards
            }

            // Apply offset for stacking effect
            let offset: CGFloat = CGFloat(cardData.count - i - 1) * 8
            cardView.transform = CGAffineTransform(translationX: 0, y: offset).scaledBy(x: 1.0 - 0.02 * CGFloat(cardData.count - i - 1), y: 1.0 - 0.02 * CGFloat(cardData.count - i - 1))
        }

        // Update current index
        currentIndex = 0
        pageControl.currentPage = currentIndex
    }
    
    // MARK: - Gesture Setup
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        stackContainer.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Handlers
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard !cardViews.isEmpty else { return }
        let topCardView = cardViews.first!
        
        switch gesture.state {
        case .began:
            initialCenter = topCardView.center
            
        case .changed:
            let translation = gesture.translation(in: stackContainer)
            topCardView.center = CGPoint(
                x: (initialCenter?.x ?? topCardView.center.x) + translation.x,
                y: initialCenter?.y ?? topCardView.center.y
            )
            
            // Calculate how far we've dragged relative to the width of the card
            let dragPercentage = min(1.0, abs(translation.x) / topCardView.frame.width)
            
            // Rotate the card slightly as it's dragged
            let rotationAngle = translation.x > 0 ? CGFloat.pi / 20 : -CGFloat.pi / 20
            topCardView.transform = CGAffineTransform(rotationAngle: rotationAngle * dragPercentage)
            
            // Make card slightly transparent as it's dragged
            topCardView.alpha = 1.0 - (dragPercentage * 0.5)
            
        case .ended, .cancelled:
            let translation = gesture.translation(in: stackContainer)
            let velocity = gesture.velocity(in: stackContainer)
            
            // If dragged left far enough or with high enough velocity, move to next card
            if translation.x < -100 || velocity.x < -500 {
                moveToNextCard()
            } else {
                // Reset to original position with animation
                UIView.animate(withDuration: 0.3) {
                    topCardView.center = self.initialCenter ?? topCardView.center
                    topCardView.transform = .identity
                    topCardView.alpha = 1.0
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - Card Cycling
    private func moveToNextCard() {
        guard !cardViews.isEmpty else { return }

        let topCard = cardViews.removeFirst()

        // Animate the top card moving away
        UIView.animate(withDuration: 0.3, animations: {
            // Move the card left and off screen
            topCard.transform = CGAffineTransform(translationX: -self.stackContainer.frame.width, y: 0)
            topCard.alpha = 0
        }, completion: { _ in
            // Move the card to the back of the stack
            topCard.removeFromSuperview()
            self.stackContainer.insertSubview(topCard, at: 0)

            // Reset its properties
            topCard.transform = CGAffineTransform(translationX: 0, y: 8 * CGFloat(self.cardViews.count)).scaledBy(x: 0.9, y: 0.9)
            topCard.alpha = 1.0

            // Add back to the array at the end
            self.cardViews.append(topCard)

            // Animate all cards moving up in the stack
            UIView.animate(withDuration: 0.2) {
                self.updateCardPositions()
            }

            // Update current index and page control
            self.currentIndex = (self.currentIndex + 1) % self.cardData.count
            self.pageControl.currentPage = self.currentIndex
        })
    }

    private func updateCardPositions() {
        for (index, cardView) in cardViews.enumerated() {
            let offset: CGFloat = CGFloat(index) * 8
            cardView.transform = CGAffineTransform(translationX: 0, y: offset).scaledBy(x: 1.0 - 0.02 * CGFloat(index), y: 1.0 - 0.02 * CGFloat(index))
        }
    }
}

// MARK: - CardView
class CardSwipeableView: UIView {
    
    // MARK: - Properties
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let readCountLabel = UILabel()
    private let readButton = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Card view setup
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        clipsToBounds = true
        
        // Shadow setup
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        // Image view setup
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        // Title label setup
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        
        // Read count label setup
        readCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        readCountLabel.textColor = .white
        readCountLabel.backgroundColor = UIColor(white: 0, alpha: 0.7)
        readCountLabel.layer.cornerRadius = 10
        readCountLabel.clipsToBounds = true
        readCountLabel.textAlignment = .center
        readCountLabel.text = "225x Reads"
        
        // Read button setup
        readButton.setTitle("Baca Selengkapnya", for: .normal)
        readButton.setTitleColor(.systemRed, for: .normal)
        readButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        readButton.contentHorizontalAlignment = .left
        readButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        readButton.semanticContentAttribute = .forceRightToLeft
        readButton.tintColor = .systemRed
        
        // Add views to hierarchy
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(readButton)
        imageView.addSubview(readCountLabel)
        
        // Setup constraints
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.7)
        }
        
        readCountLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        readButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Configuration
    func configure(with title: String, backgroundColor: UIColor) {
        titleLabel.text = title
        imageView.backgroundColor = backgroundColor
    }
}
