//
//  ExampleTabCollectionView.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/01/25.
//

import UIKit
import SnapKit

class ExampleTabCollectionViewController: UIViewController {
    
    private let tabTitles = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    private var selectedIndex = 0
    
    // Dummy data untuk foto
      private let photos = [
          "ads1", "ads2", "promo1",
          "promo2", "promo3", "ads1",
          "ads2", "promo1", "ads1",
          "promo2", "promo3",
      ]
    
    // MARK: - UI Components
    private lazy var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: "TabCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let sliderContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal
          layout.minimumInteritemSpacing = 0
          layout.minimumLineSpacing = 0
          
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.backgroundColor = .white
          collectionView.isPagingEnabled = true
          collectionView.showsHorizontalScrollIndicator = false
          collectionView.register(PhotoPageCell.self, forCellWithReuseIdentifier: "PhotoPageCell")
          collectionView.delegate = self
          collectionView.dataSource = self
          return collectionView
      }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tabCollectionView)
        view.addSubview(sliderContainerView)
        sliderContainerView.addSubview(sliderView)
        view.addSubview(photoCollectionView)
        
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        sliderContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(tabCollectionView)
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.height.equalTo(2)
        }
        
        sliderView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(tabCollectionView).dividedBy(CGFloat(tabTitles.count))
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sliderContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func updateSliderPosition(animated: Bool = true) {
        guard let cell = tabCollectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) else { return }

//        let width = tabCollectionView.bounds.width / CGFloat(tabTitles.count)
        let xOffset = cell.frame.minX
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.sliderView.frame.origin.x = xOffset
            }
        } else {
            sliderView.frame.origin.x = xOffset
            sliderView.frame.size.width = cell.frame.width
        }
        
        // Scroll to make selected tab visible
          tabCollectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0),
                                       at: .centeredHorizontally,
                                       animated: animated)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ExampleTabCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
            cell.configure(with: tabTitles[indexPath.item], isSelected: selectedIndex == indexPath.item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPageCell", for: indexPath) as! PhotoPageCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
           return CGSize(width: collectionView.bounds.width / CGFloat(tabTitles.count), height: 44)
       } else {
           return collectionView.bounds.size
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == tabCollectionView {
             selectedIndex = indexPath.item
             updateSliderPosition()
             photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
             tabCollectionView.reloadData()
         }
     }
     
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         if scrollView == photoCollectionView {
             let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
             selectedIndex = page
             updateSliderPosition()
             tabCollectionView.reloadData()
         }
     }
}

// MARK: - Custom Cells
class TabCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .systemBlue : .gray
    }
}

// New PhotoPageCell that contains a grid of photos
class PhotoPageCell: UICollectionViewCell {
    
    // Dummy data untuk foto
      private let photos = [
          "ads1", "ads2", "promo1",
          "promo2", "promo3", "ads1",
          "ads2", "promo1", "ads1",
          "promo2", "promo3",
      ]
    
    private lazy var gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false // Disable scrolling for grid
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(gridCollectionView)
        gridCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Grid Collection View Implementation
extension PhotoPageCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count // 3x3 grid
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        // Configure cell with image
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 2) / 3 // 2 adalah total spacing
        return CGSize(width: width, height: width)
    }
}

class PhotoCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
