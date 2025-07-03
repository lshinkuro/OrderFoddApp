//
//  ProfilesVC.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/01/25.
//

import Foundation
import UIKit
import SnapKit

class ProfilesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        // Background Image
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "background") // Ganti dengan nama file gambar Anda
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Profile Section
        let profileContainer = UIView()
        profileContainer.backgroundColor = .white
        profileContainer.layer.cornerRadius = 20
        profileContainer.layer.shadowColor = UIColor.black.cgColor
        profileContainer.layer.shadowOpacity = 0.1
        profileContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        profileContainer.layer.shadowRadius = 8
        view.addSubview(profileContainer)
        profileContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(200)
        }
        
        // Profile Image
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile") // Ganti dengan nama file gambar profil
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 4
        profileContainer.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        // Name Label
        let nameLabel = UILabel()
        nameLabel.text = "Maria Elliott"
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        profileContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // Location Label
        let locationLabel = UILabel()
        locationLabel.text = "Albany, New York"
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .systemBlue
        locationLabel.textAlignment = .center
        profileContainer.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        // Stats
        let statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.distribution = .equalSpacing
        profileContainer.addSubview(statsStackView)
        statsStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let stats = [
            ("120", "Purchased"),
            ("271", "Wished"),
            ("12K", "Likes")
        ]
        
        for stat in stats {
            let statView = createStatView(value: stat.0, label: stat.1)
            statsStackView.addArrangedSubview(statView)
        }
        
        // Collection Section
        let collectionLabel = UILabel()
        collectionLabel.text = "Collection"
        collectionLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(collectionLabel)
        collectionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileContainer.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        let collectionScrollView = UIScrollView()
        collectionScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionScrollView)
        collectionScrollView.snp.makeConstraints { make in
            make.top.equalTo(collectionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        let collectionStackView = UIStackView()
        collectionStackView.axis = .horizontal
        collectionStackView.spacing = 16
        collectionScrollView.addSubview(collectionStackView)
        collectionStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
        
        for collection in ["Winter", "Summer", "Autumn"] {
            let cardView = createCollectionCard(title: collection)
            collectionStackView.addArrangedSubview(cardView)
        }
        
        // Tags Section
        let tagsLabel = UILabel()
        tagsLabel.text = "Tags"
        tagsLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(tagsLabel)
        tagsLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionScrollView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        let tagsStackView = UIStackView()
        tagsStackView.axis = .horizontal
        tagsStackView.spacing = 8
        tagsStackView.distribution = .fillProportionally
        view.addSubview(tagsStackView)
        tagsStackView.snp.makeConstraints { make in
            make.top.equalTo(tagsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        for tag in ["Kurtas", "Jackets", "Lehenga", "SalwarSuits", "Gown"] {
            let tagButton = UIButton()
            tagButton.setTitle(tag, for: .normal)
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.backgroundColor = .systemBlue
            tagButton.layer.cornerRadius = 15
            tagButton.titleLabel?.font = .systemFont(ofSize: 14)
//            tagButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            tagsStackView.addArrangedSubview(tagButton)
        }
    }
    
    private func createStatView(value: String, label: String) -> UIView {
        let container = UIView()
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 18)
        valueLabel.textAlignment = .center
        container.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        
        let labelLabel = UILabel()
        labelLabel.text = label
        labelLabel.font = .systemFont(ofSize: 14)
        labelLabel.textColor = .gray
        labelLabel.textAlignment = .center
        container.addSubview(labelLabel)
        labelLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func createCollectionCard(title: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .systemPink
        card.layer.cornerRadius = 10
        card.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        card.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return card
    }
}
