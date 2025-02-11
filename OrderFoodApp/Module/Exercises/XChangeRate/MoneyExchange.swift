//
//  MoneyExchange.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MoneyExchangeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // UI Components
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Money Exchange"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Current Balance: "
        label.textColor = .gray
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$5,156"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let fromCurrencyView = CurrencyInputView(currency: "USD")
    private let toCurrencyView = CurrencyInputView(currency: "BDT")
    
    private let feeView = ExchangeDetailView(title: "Fee")
    private let rateView = ExchangeDetailView(title: "Rate")
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [backButton, titleLabel, balanceLabel, balanceAmountLabel,
         fromCurrencyView, toCurrencyView, feeView, rateView, continueButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        
        fromCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        
        toCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(fromCurrencyView.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(16)
        }
        
        // Setup constraints
        feeView.snp.makeConstraints { make in
            make.top.equalTo(toCurrencyView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }

        rateView.snp.makeConstraints { make in
            make.top.equalTo(feeView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }

        // Update nilai jika diperlukan
        feeView.setValue("$2.00")
        rateView.setValue("84.83 BDT")
    }
    
    private func setupBindings() {
        // RxSwift bindings
        fromCurrencyView.amountTextField.rx.text.orEmpty
            .map { Double($0) ?? 0 }
            .bind { [weak self] amount in
                // Calculate exchange rate and update toCurrencyView
                let rate = 84.83
                let convertedAmount = amount * rate
                self?.toCurrencyView.amountTextField.text = String(format: "%.2f", convertedAmount)
            }
            .disposed(by: disposeBag)
    }
}

import UIKit
import SnapKit

class CurrencyInputView: UIView {
    // MARK: - UI Components
    let amountTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 24, weight: .medium)
        tf.keyboardType = .decimalPad
        tf.textAlignment = .left
        tf.backgroundColor = .clear
        tf.tintColor = .systemBlue
        return tf
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.systemGray5.cgColor
        return iv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - Properties
    private var currency: String
    
    // MARK: - Initialization
    init(currency: String) {
        self.currency = currency
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        configureCurrency(currency)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // Add subviews
        addSubview(containerView)
        [amountTextField, currencyLabel, flagImageView].forEach {
            containerView.addSubview($0)
        }
        
        // Additional styling
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.05
    }
    
    private func setupConstraints() {
        // Container view constraints
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(64) // Adjust height as needed
        }
        
        // Flag image constraints
        flagImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30) // Size for flag
        }
        
        // Currency label constraints
        currencyLabel.snp.makeConstraints { make in
            make.right.equalTo(flagImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(50) // Adjust based on currency code length
        }
        
        // Amount text field constraints
        amountTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(currencyLabel.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configuration Methods
    private func configureCurrency(_ currency: String) {
        currencyLabel.text = currency
        
        // Set flag image based on currency
        switch currency {
        case "USD":
            flagImageView.image = UIImage(named: "flag_usa")
            // If using SF Symbols for flags:
            // flagImageView.image = UIImage(systemName: "flag.fill")
        case "BDT":
            flagImageView.image = UIImage(named: "flag_bangladesh")
        default:
            flagImageView.image = UIImage(named: "flag_default")
        }
    }
    
    // MARK: - Public Methods
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func getAmount() -> Double? {
        return Double(amountTextField.text ?? "0")
    }
}

// MARK: - Extension for Additional Setup
extension CurrencyInputView {
    func setupForInput() {
        // Make text field first responder
        amountTextField.becomeFirstResponder()
    }
    
    func setupPlaceholder(_ placeholder: String) {
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.systemGray3,
                .font: UIFont.systemFont(ofSize: 24, weight: .medium)
            ]
        )
    }
}

import UIKit
import SnapKit

class ExchangeDetailView: UIView {
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Properties
    private var title: String
    
    // MARK: - Initialization
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupUI()
        configureView(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        [titleLabel, valueLabel].forEach { addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureView(_ title: String) {
        titleLabel.text = "- \(title)"
        
        // Set default values based on title
        switch title.lowercased() {
        case "fee":
            valueLabel.text = "$2.00"
        case "rate":
            valueLabel.text = "84.83 BDT"
        default:
            valueLabel.text = "0.00"
        }
    }
    
    // MARK: - Public Methods
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    func getValue() -> String {
        return valueLabel.text ?? ""
    }
}

// MARK: - Extension for Additional Customization
extension ExchangeDetailView {
    func updateStyle(titleColor: UIColor = .systemGray, valueColor: UIColor = .darkGray) {
        titleLabel.textColor = titleColor
        valueLabel.textColor = valueColor
    }
    
    func updateFonts(titleFont: UIFont = .systemFont(ofSize: 16),
                    valueFont: UIFont = .systemFont(ofSize: 16, weight: .medium)) {
        titleLabel.font = titleFont
        valueLabel.font = valueFont
    }
}
