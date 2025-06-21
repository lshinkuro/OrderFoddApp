//
//  EntertainmentCommerceViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/03/25.
//

import Foundation
import UIKit
import SnapKit

class EntertainmentCommerceViewController: UIViewController {
    
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
        tableView.register(SlideableCollectionCell.self, forCellReuseIdentifier: "SlideableCollectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    // MARK: - Actions
    @objc private func tabChanged(_ sender: UISegmentedControl) {
        currentTab = sender.selectedSegmentIndex
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension EntertainmentCommerceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Section for sliding cards and another for other content
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5 // 1 row for sliding cards, 5 for other content
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideableCollectionCell", for: indexPath) as! SlideableCollectionCell
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

// MARK: - SlideableCollectionCell
class SlideableCollectionCell: UITableViewCell {
    
    // MARK: - Properties
    private let collectionView: UICollectionView
    private var currentPage = 0
    private let pageControl = UIPageControl()
    
    // Mock data for the cards
    private let cardTitles = [
        "Kode Redeem ML 11 Maret 2025 Edisi Ramadan",
        "Promo Game Terbaru",
        "Turnamen Mobile Legends",
        "Diskon Skin Limited Edition"
    ]
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Configure collection view flow layout for horizontal scrolling
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // Initialize collection view with layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
        
        // Configure page control
        pageControl.numberOfPages = cardTitles.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray
        
        // Add views to hierarchy
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        // Setup constraints
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - CollectionView Configuration
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false // We'll implement custom snapping
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
    }
}

// MARK: - CollectionView Delegate & DataSource
extension SlideableCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.configure(with: cardTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 60 // Account for padding
        return CGSize(width: width, height: 300)
    }
    
    // MARK: - Smooth Scrolling with Snapping
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
        // Update page control
        currentPage = Int(roundedIndex)
        pageControl.currentPage = currentPage
    }
    
    // Add animation when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.frame.width / 2
        
        for cell in collectionView.visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell) else { continue }
            
            let cellCenter = collectionView.layoutAttributesForItem(at: indexPath)?.center.x ?? 0
            let distance = abs(cellCenter - centerX)
            let scale = max(0.8, min(1.0, 1 - distance / scrollView.frame.width))
            
            // Apply transform to cell
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

// MARK: - CardCollectionViewCell
class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let cardView = UIView()
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
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        cardView.clipsToBounds = true
        
        // Shadow setup
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        
        // Image view setup
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
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
        
        // Read button setup
        readButton.setTitle("Baca Selengkapnya", for: .normal)
        readButton.setTitleColor(.systemRed, for: .normal)
        readButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        readButton.contentHorizontalAlignment = .left
        
        // Add views to hierarchy
        contentView.addSubview(cardView)
        cardView.addSubview(imageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(readButton)
        imageView.addSubview(readCountLabel)
        
        // Setup constraints
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(cardView.snp.height).multipliedBy(0.7)
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
    func configure(with title: String) {
        titleLabel.text = title
        readCountLabel.text = "225x Reads"
        
        // Set placeholder image color
        imageView.backgroundColor = randomColor()
    }
    
    // Generate random pastel color for card backgrounds
    private func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 100) / 100
        return UIColor(hue: hue, saturation: 0.3, brightness: 0.9, alpha: 1.0)
    }
}
