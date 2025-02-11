//
//  PaymentViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/01/25.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Models
struct PaymentSection {
    var title: String
    var items: [PaymentMethod]
    var isExpanded: Bool
}

struct PaymentMethod {
    var name: String
    var icon: String
    var amount: Double?
    var needsActivation: Bool
}

protocol PaymentMethodViewControllerDelegate: AnyObject {
    func didSelectPaymentMethod(_ method: PaymentMethod)
    func didTapActivate(for method: PaymentMethod)
}

class PaymentMethodViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: PaymentMethodViewControllerDelegate?
    private var sections: [PaymentSection] = []
    private var selectedIndexPath: IndexPath?
    

    private lazy var warningView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        let iconView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        iconView.tintColor = .systemBlue
        
        let label = UILabel()
        label.text = "Cash on Delivery are not available at this time, please select other payment method."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        view.addSubview(iconView)
        view.addSubview(label)
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(iconView)
        }
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PaymentMethodCell.self, forCellReuseIdentifier: "PaymentCell")
        table.register(PaymentSectionHeader.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.rowHeight = 70
        return table
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Payment Method", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Payment Methode"
        
        view.addSubview(warningView)
        view.addSubview(tableView)
        view.addSubview(selectButton)
        
        
        warningView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(warningView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(selectButton.snp.top).offset(-20)
        }
        
        selectButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func setupData() {
        sections = [
            PaymentSection(title: "E-Wallet", items: [
                PaymentMethod(name: "Paypal", icon: "paypal.icon", amount: 11.43, needsActivation: false),
                PaymentMethod(name: "Gopay", icon: "gopay.icon", amount: 123.43, needsActivation: false),
                PaymentMethod(name: "Shopeepay", icon: "shopeepay.icon", amount: nil, needsActivation: true),
                PaymentMethod(name: "OVO", icon: "ovo.icon", amount: nil, needsActivation: true),
                PaymentMethod(name: "DANA", icon: "dana.icon", amount: nil, needsActivation: true),
                PaymentMethod(name: "Wise", icon: "wise.icon", amount: nil, needsActivation: true)
            ], isExpanded: true),
            PaymentSection(title: "Bank Transfer", items: [
                PaymentMethod(name: "Bank of America", icon: "boa.icon", amount: nil, needsActivation: false),
                PaymentMethod(name: "Citibank", icon: "citi.icon", amount: nil, needsActivation: false),
                PaymentMethod(name: "Wells Fargo", icon: "wellsfargo.icon", amount: nil, needsActivation: false)
            ], isExpanded: false)
        ]
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func selectButtonTapped() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        let method = sections[selectedIndexPath.section].items[selectedIndexPath.row]
        delegate?.didSelectPaymentMethod(method)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isExpanded ? sections[section].items.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentMethodCell
        let method = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: method)
        cell.isSelected = indexPath == selectedIndexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = sections[indexPath.section].items[indexPath.row]
        if !method.needsActivation {
            selectedIndexPath = indexPath
            tableView.reloadData()
            selectButton.isEnabled = true
            selectButton.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! PaymentSectionHeader
        header.configure(with: sections[section].title, isExpanded: sections[section].isExpanded)
        header.onTap = { [weak self] in
            self?.toggleSection(section)
        }
        return header
    }
    
    private func toggleSection(_ section: Int) {
        sections[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

// MARK: - PaymentMethodCellDelegate
extension PaymentMethodViewController: PaymentMethodCellDelegate {
    func didTapActivate(in cell: PaymentMethodCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let method = sections[indexPath.section].items[indexPath.row]
        delegate?.didTapActivate(for: method)
    }
}

// MARK: - Custom Cell
protocol PaymentMethodCellDelegate: AnyObject {
    func didTapActivate(in cell: PaymentMethodCell)
}

class PaymentMethodCell: UITableViewCell {
    weak var delegate: PaymentMethodCellDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Activate", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(activateButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(activateButton)
        containerView.addSubview(checkmarkImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        activateButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with method: PaymentMethod) {
        iconImageView.image = UIImage(named: method.icon)
        nameLabel.text = method.name
        
        if let amount = method.amount {
            amountLabel.text = "$\(amount)"
            amountLabel.isHidden = false
            activateButton.isHidden = true
        } else {
            amountLabel.isHidden = true
            activateButton.isHidden = !method.needsActivation
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        containerView.layer.borderColor = selected ? UIColor.systemBlue.cgColor : UIColor.systemGray5.cgColor
        checkmarkImageView.isHidden = !selected
    }
    
    @objc private func activateButtonTapped() {
        delegate?.didTapActivate(in: self)
    }
}

// MARK: - Section Header
class PaymentSectionHeader: UITableViewHeaderFooterView {
    var onTap: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Section Header (continued)
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func configure(with title: String, isExpanded: Bool) {
        titleLabel.text = title
        let arrowImage = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        arrowImageView.image = arrowImage
        
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    @objc private func headerTapped() {
        onTap?()
    }
}

extension PaymentMethodViewController {
    // Helper method to show loading state
    func showLoading() {
        selectButton.isEnabled = false
        selectButton.setTitle("Loading...", for: .disabled)
    }
    
    // Helper method to hide loading state
    func hideLoading() {
        selectButton.isEnabled = true
        selectButton.setTitle("Select Payment Method", for: .normal)
    }
    
    // Helper method to show error
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
