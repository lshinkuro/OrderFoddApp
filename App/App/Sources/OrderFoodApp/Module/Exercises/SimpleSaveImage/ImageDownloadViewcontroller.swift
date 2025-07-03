//
//  ImageDownloadViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 19/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class ImageDownloadViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let downloadButton = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup ImageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
        
        // Setup Button
        downloadButton.setTitle("Download Image", for: .normal)
        view.addSubview(downloadButton)
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func loadImage() {
        let imageURL = URL(string: "https://images.unsplash.com/photo-1742124513359-8cd0a9305d47?q=80&w=3086&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fA%3D%3D")! // Ganti dengan URL gambar yang diinginkan
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func setupBindings() {
        downloadButton.rx.tap
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.requestPhotoLibraryPermission()
            }
            .flatMapLatest { [weak self] granted -> Observable<Bool> in
                guard granted else {
                    self?.showPermissionDeniedAlert()
                    return .just(false)
                }
                return self?.saveImageToGallery() ?? .just(false)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                self?.showAlert(success: success)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestPhotoLibraryPermission() -> Observable<Bool> {
        return Observable.create { observer in
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized, .limited:
                observer.onNext(true)
                observer.onCompleted()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        observer.onNext(newStatus == .authorized || newStatus == .limited)
                        observer.onCompleted()
                    }
                }
            case .denied, .restricted:
                observer.onNext(false)
                observer.onCompleted()
            @unknown default:
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func saveImageToGallery() -> Observable<Bool> {
        return Observable.create { observer in
            guard let image = self.imageView.image else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
            
            // Observer tidak menyelesaikan sampai kita menerima callback dari UIImageWriteToSavedPhotosAlbum
            return Disposables.create()
        }
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let success = (error == nil)
        DispatchQueue.main.async {
            self.showAlert(success: success)
        }
    }
    
    private func showAlert(success: Bool) {
        let alert = UIAlertController(
            title: success ? "Success" : "Error",
            message: success ? "Image saved to gallery" : "Failed to save image",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Permission Denied",
            message: "Please enable photo library access in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
