//
//  AdsViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 09/10/24.
//

import UIKit
import WebKit

class AdsViewController: BaseViewController {
    
    @IBOutlet weak var toolbarView: ToolBarView!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var bottomView: UIView!
    
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self
        toolbarView.configure(title: "Portal Berita")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        
        if  let urlString = url,
            let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
}

extension AdsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.bottomView.isHidden = false
        self.bottomView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut) { [weak self] () in
            guard let self = self else { return }
            self.bottomView.transform = .identity
        }
    }
}
