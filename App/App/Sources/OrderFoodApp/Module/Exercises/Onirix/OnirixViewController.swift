//
//  OnirixViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation

import UIKit
import WebKit
import SnapKit

final class OnirixWebViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let onirixURL = "https://studio.onirix.com"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadContent()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        setupWebView()
        setupActivityIndicator()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func loadContent() {
        guard let url = URL(string: onirixURL) else {
            showError(message: "Invalid URL")
            return
        }
        
        activityIndicator.startAnimating()
        webView.load(URLRequest(url: url))
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension OnirixWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showError(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showError(message: error.localizedDescription)
    }
}
