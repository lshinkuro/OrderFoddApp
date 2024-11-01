//
//  ExampleSnapkitViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FloatingPanel

class ExampleSnapkitViewController: UIViewController {
    
    let bag = DisposeBag()
    // Gambar Profil
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_image")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // Nama Pengguna
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // Bio Pengguna
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer | Tech Enthusiast"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // Tombol Edit Profil
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    let labelOne: UILabel = {
         let label = UILabel()
         label.text = "Label One"
         label.textColor = .gray
         label.textAlignment = .center
         return label
     }()
     
     let labelTwo: UILabel = {
         let label = UILabel()
         label.text = "Label Two"
         label.textColor = .gray
         label.textAlignment = .center
         return label
     }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal  // Bisa diubah ke .horizontal jika ingin horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        actionView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.add(profileImageView, nameLabel, bioLabel, editProfileButton, stackView)
        stackView.addStack(labelOne, labelTwo)
        
        // Mengatur layout menggunakan SnapKit
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(editProfileButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    func actionView(){
        editProfileButton.rx.tap.subscribe { _ in
            let fpc = CustomFPC()
            let vc = ExampleFPCViewController()
            fpc.delegate = self
            fpc.setupAppearance()
            vc.heightFPC.subscribe = { [weak self] value in
                guard self != nil, let height = value else { return }
                fpc.layout = FloatingPanelContentFitLayout(heightOfContent: height)
                fpc.invalidateLayout()
            }
            fpc.set(contentViewController: vc)
            self.present(fpc, animated: true, completion: nil)
        }.disposed(by: bag)
    }
    
    
    
}

extension ExampleSnapkitViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let loc = fpc.surfaceLocation
        let minY = fpc.surfaceLocation(for: .half).y

        let maxY: CGFloat
        maxY = fpc.surfaceLocation(for: .half).y
        fpc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
    }
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee == .tip {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}


class CustomFPC: FloatingPanelController {
    func setupAppearance() {
        self.surfaceView.appearance.cornerRadius = 20
        self.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        self.surfaceView.grabberHandleSize = .init(width: 44, height: 6)
        self.surfaceView.grabberHandle.backgroundColor = UIColor.foodGrey3
    }
}

