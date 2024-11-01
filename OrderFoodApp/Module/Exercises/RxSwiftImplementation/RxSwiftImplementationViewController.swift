//
//  RxSwiftImplementationViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift


enum OperatorCeluller: String, CaseIterable {
    case indosat = "Indosat"
    case telkomsel = "Telkomsel"
    case axis = "Axis"
    case xl = "Xl"
    case smartfren
    
    func setImage() -> UIImage? {
        switch self {
        case .telkomsel:
            return UIImage(named: "telkomsel_logo")
        case .xl:
            return UIImage(named: "xl_logo")
        case .indosat:
            return UIImage(named: "indosat_logo")
        case .axis:
            return UIImage(named: "axis_logo")
        default:
            return UIImage(named: "unknown_operator")
        }
    }
}

class RxSwiftImplementationViewController: BaseViewController {
    
    @IBOutlet weak var operatorImageView: UIImageView!
    @IBOutlet weak var rxLabel: UILabel!
    @IBOutlet weak var changeNumberButton: UIButton!
    
    @IBOutlet weak var usernameField: CustomInputField!
    @IBOutlet weak var passwordField: CustomInputField!
    
    @IBOutlet weak var phoneNumberField: CustomInputField!
    
    
    let viewModel = RxSwiftImplementationViewModel()
    
    let name = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testBehaviourSubject()
        testPublishRelay()
        setup()
        testRxCocoa()
    }
    
    func setup() {
        usernameField.setup(title: "username", placeholder: "enter username")
        passwordField.setup(title: "password", placeholder: "enter password")
        phoneNumberField.setup(title: "phone Number", placeholder: "enter phone number")
        
        phoneNumberField.textfield.keyboardType = .numberPad
        
        
        changeNumberButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.setValuebehaviorSubject()
            self.viewModel.triggerRelay()
        }.disposed(by: disposeBag)
        
        usernameField.textfield
            .rx
            .text
            .compactMap { $0 }
            .map { $0.count >= 2 && $0.count <= 16 }
            .subscribe(onNext: { isError in
                if  self.usernameField.textfield.text?.count == 0 {
                    self.usernameField.errorLabel.isHidden = true
                } else {
                    self.usernameField.errorLabel.text = "username harus lebih dari 2 dan kurang dari 16 char"
                    self.usernameField.errorLabel.isHidden = isError
                    print ("validation : \(isError)")
                }
            })
            .disposed(by: disposeBag)
        
        
        passwordField.textfield
            .rx
            .text
            .orEmpty.bind(to: name)
            .disposed(by: disposeBag)
        
        
        phoneNumberField.textfield.rx.text.orEmpty
            .map { $0.separateNumber()}
            .subscribe(onNext: { [weak self] formattedString, operatorName in
                guard let self = self else { return }
                
                // Bind nomor telepon yang terformat ke phoneNumberField
                self.phoneNumberField.textfield.text = formattedString
                self.phoneNumberField.logoImgView.isHidden = false
                self.phoneNumberField.logoImgView.image =  OperatorCeluller(rawValue: operatorName)?.setImage()
               
            })
            .disposed(by: disposeBag)
    }
    
    func testRx() {
        /*Observable.of(1,2,3,4,5,6)
         .subscribe(onNext: { [weak self] data in
         guard let self = self else { return }
         self.rxLabel.text = String(data)})
         .disposed(by: disposeBag)*/
        
        
        // Observable sequence with timer
        // Observable sequence
        let items =  Observable.of(1, 2, 3, 4, 5, 6, 8, 10, 12)
        
        let items2 = Observable.of(14,18,20)
        
        Observable.merge(items, items2)
            .filter { $0 % 2 == 0}
            .map { $0 * 2}
            .concatMap { item -> Observable<Int> in
                // Delay each item by 1 second
                return Observable.just(item).delay(.seconds(1), scheduler: MainScheduler.instance)}
            .flatMap { Observable.of($0, $0 + 10)}
            .subscribe { [weak self] data in
                guard let self = self else { return }
                self.rxLabel.text = String(data)
            }.disposed(by: disposeBag)
    }
    
    func testSubject() {
        viewModel.subject.onNext(2)
        viewModel.subject.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.rxLabel.text = String(data)
        }).disposed(by: disposeBag)
        viewModel.subject.onNext(7)
    }
    
    func testBehaviourSubject() {
        viewModel.behaviorSubject.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.rxLabel.text = data
        }).disposed(by: disposeBag)
    }
    
    func testPublishRelay() {
        viewModel.buttonTapRelay.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.showCustomPopUp(PopUpModel(title: "RxSwift", description: "test publis relay", image: "ads1"))
        }).disposed(by: disposeBag)
    }
    
    func testRxCocoa() {
        //        Observable.zip(name.asObservable(), password.asObservable()).subscribe(onNext: { [weak self] data in
        //            guard let self = self else { return }
        //            print("datanya \(data)")
        //
        //        }).disposed(by: disposeBag)
        
        name.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            print("Text field updated: \(text)")
        }).disposed(by: disposeBag)
    }
    
}

extension String {
    func separateNumber() -> (String,String) {
        // Batasi input hingga 15 karakter tanpa spasi
        let cleanInput = self.replacingOccurrences(of: " ", with: "")
        let limitedInput = String(cleanInput.prefix(15))
        
        // Periksa apakah nomor valid (harus diawali dengan 02 atau 628)
    
        
        let prefix = String(limitedInput.prefix(4))
        var operatorName = ""
        
        switch prefix {
        case "0857", "0856", "0858":
            operatorName = "Indosat"
        case "0813", "0812", "0853", "0852":
            operatorName = "Telkomsel"
        case "0878", "0818", "0819", "0877":
            operatorName = "Xl"
        case "0838","0831":
            operatorName = "Axis"
        default:
            operatorName = "Unknown Operator"
        }
        
        // Tambahkan spasi setiap 4 karakter
        var formattedString = ""
        for (index, character) in limitedInput.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        
        return (formattedString, operatorName)
    }
}
