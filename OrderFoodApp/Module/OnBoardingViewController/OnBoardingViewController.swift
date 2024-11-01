//
//  OnBoardingViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import UIKit



class OnBoardingViewController: BaseViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    let dataOnboard = onboardsData
    private var currentPage: Int = 0
    
    var coordinator: OnboardingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        let welcomeMessage = RemoteConfigManager.shared.versionApp
        self.versionLabel.text = "app-version: \(welcomeMessage)"

    }
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func setup() {
        
        // Register the cell's XIB file with the collection view
        let nib = UINib(nibName: "OnBoardingCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OnBoardingCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = layout
        
        pageControl.pageIndicatorTintColor = .foodBrightCoral1
        pageControl.currentPageIndicatorTintColor = .gray
        
        loginButton.addTarget(self, action: #selector(actionLoginButton(_:)), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(actionLoginButton(_:)), for: .touchUpInside)
        
        skipButton.addTarget(self, action: #selector(actionLoginButton(_:)), for: .touchUpInside)
        
    }
    
    private func moveToNextPage() {
        currentPage += 1
        scrollToPage(page: currentPage, animated: true)
    }
    
    private func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.collectionView.scrollRectToVisible(frame, animated: animated)
    }
    

    
    
    @objc func actionLoginButton(_ sender: UIButton) {
        switch sender {
        case loginButton:
            self.moveToLogin()
        case createAccountButton:
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case skipButton:
            if self.currentPage == 2 {
                self.moveToLogin()
            } else {
                self.moveToNextPage()
            }
        default:
            break
        }
    }
    
    func moveToLogin() {
        coordinator?.showLogin()
    }

}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataOnboard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(data: dataOnboard[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(
            (collectionView.contentOffset.x / collectionView.frame.width)
                .rounded(.toNearestOrAwayFromZero))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            currentPage = indexPath.row
        }
    }
}
    
