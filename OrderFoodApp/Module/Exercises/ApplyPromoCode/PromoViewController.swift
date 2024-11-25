//
//  PromoViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/11/24.
//

import Foundation
import UIKit
import SnapKit

protocol PromoCodeViewControllerDelegate: AnyObject {
    func didSelectPromo(_ promo: PromoCode)
}

struct PromoCode {
    let code: String
    let description: String
    var isSelected: Bool = false
}

class PromoCodeViewController: UIViewController {
    // MARK: - Properties
    private var promos: [PromoCode] = []
    weak var delegate: PromoCodeViewControllerDelegate?
    private var selectedPromo: PromoCode?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(PromoCodeCell.self, forCellReuseIdentifier: "PromoCell")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDummyData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Promo Code"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(applyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(applyButton.snp.top).offset(-16)
        }
        
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    private func setupDummyData() {
        promos = [
            PromoCode(code: "SAVE10", description: "Save 10% on your purchase"),
            PromoCode(code: "FREESHIP", description: "Free shipping on orders over $50"),
            PromoCode(code: "EXTRA15", description: "Extra 15% off for new customers")
        ]
    }
    
    // MARK: - Actions
    @objc private func applyButtonTapped() {
        if let selectedPromo = selectedPromo {
            delegate?.didSelectPromo(selectedPromo)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PromoCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath) as? PromoCodeCell else {
            return UITableViewCell()
        }
        
        let promo = promos[indexPath.row]
        cell.configure(with: promo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect previously selected promo
        if let previousIndex = promos.firstIndex(where: { $0.isSelected }) {
            promos[previousIndex].isSelected = false
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            tableView.reloadRows(at: [previousIndexPath], with: .none)
        }
        
        // Select new promo
        promos[indexPath.row].isSelected = true
        selectedPromo = promos[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
        
        configButton(enable: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func configButton(enable: Bool) {
        if enable {
            // Enable apply button
            applyButton.isEnabled = true
            applyButton.backgroundColor = .systemBlue
        } else {
            applyButton.isEnabled = false
            applyButton.backgroundColor = .gray
        }
    }
}

// MARK: - PromoCodeCell
class PromoCodeCell: UITableViewCell {
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(codeLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(checkImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalTo(checkImageView.snp.left).offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(checkImageView.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(24)
        }
    }
    
    // MARK: - Configuration
    func configure(with promo: PromoCode) {
        codeLabel.text = promo.code
        descriptionLabel.text = promo.description
        
        if promo.isSelected {
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            containerView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        } else {
            checkImageView.image = UIImage(systemName: "circle")
            containerView.backgroundColor = .systemGray6
        }
    }
}
