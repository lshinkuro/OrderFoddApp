import UIKit
import SnapKit
import RxSwift
import RxRelay


class CustomProfileInputField: UIView {
    
    internal let titleLabel = UILabel()
    internal let textField = UITextField()
    
    let disposeBag = DisposeBag()
    
    init(title: String,
         placeholder: String,
         text: BehaviorRelay<String>) {
        super.init(frame: .zero)
        setupView()
        bind(title: title, placeholder: placeholder, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        addSubview(titleLabel)
        textField.borderStyle = .roundedRect
        addSubview(textField)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func bind(title: String,
                      placeholder: String,
                      text: BehaviorRelay<String>) {
        titleLabel.text = title
        textField.placeholder = placeholder
    
        text.bind(to: textField.rx.text).disposed(by: disposeBag)
        textField.rx.text.orEmpty
            .bind(to: text)
            .disposed(by: disposeBag)
        
    }
}
