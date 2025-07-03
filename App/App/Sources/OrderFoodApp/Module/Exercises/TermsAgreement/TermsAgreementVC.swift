//
//  TermsAgreementVC.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/02/25.
//

import UIKit
import SnapKit

class TermsAgreementVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let agreementLabel = UILabel()
    private let checkBox = UIButton()
    private let nextButton = UIButton()
    
    private var isScrolledToBottom = false {
        didSet {
            updateButtonState()
        }
    }
    private var isChecked = false {
        didSet {
            updateButtonState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(agreementLabel)
        view.addSubview(checkBox)
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(checkBox.snp.top).offset(-10)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        agreementLabel.text = "Syarat & Ketentuan \n\n" + String(repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut quam at dui consectetur cursus eu ut odio. Duis sagittis a nisl sed blandit. Nam venenatis tempor nibh sit amet venenatis. Nullam a est placerat, rutrum lacus at, ultrices diam. Phasellus tempus, erat nec molestie bibendum, lectus nunc sodales quam, a convallis arcu lorem et augue. Quisque nec aliquam elit. Vestibulum aliquet eros massa, quis fermentum tortor vehicula congue. Ut non vehicula magna, quis eleifend ligula. Aenean eleifend nisl turpis, sit amet suscipit nunc commodo quis. Praesent molestie magna mi, sed blandit libero pharetra ac. Phasellus maximus mollis tellus, ut accumsan nibh tempor sed.\n", count: 5)
        agreementLabel.numberOfLines = 0
        
        agreementLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        checkBox.setTitle(" Saya Setuju", for: .normal)
        checkBox.setTitleColor(.black, for: .normal)
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        checkBox.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        nextButton.setTitle("Lanjut", for: .normal)
        nextButton.backgroundColor = .gray
        nextButton.layer.cornerRadius = 8
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        scrollView.delegate = self
    }
    
    @objc private func checkBoxTapped() {
        guard isScrolledToBottom else { return }
        isChecked.toggle()
        checkBox.isSelected = isChecked
    }
    
    @objc private func nextButtonTapped() {
        let nextVC = UIViewController()
        nextVC.view.backgroundColor = .white
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateButtonState() {
        nextButton.isEnabled = isScrolledToBottom && isChecked
        nextButton.backgroundColor = nextButton.isEnabled ? .blue : .gray
    }
}

extension TermsAgreementVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomOffset = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        isScrolledToBottom = bottomOffset >= contentHeight - 10
    }
}
