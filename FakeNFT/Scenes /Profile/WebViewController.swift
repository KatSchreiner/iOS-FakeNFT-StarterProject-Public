//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Public Properties
    var urlString: String?
    
    // MARK: - Private Properties
    private var webView: WKWebView
    
    private lazy var backButton: BackButton = {
        let backButton = BackButton(target: self, action: #selector(didTapBack))
        return backButton
    }()
    
    // MARK: - Initializers
    init(urlString: String? = nil, webView: WKWebView) {
        self.urlString = urlString
        self.webView = webView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebPage()
    }
    
    // MARK: - IB Actions
    @objc
    private func didTapBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        navigationItem.title = "About".localized()
        navigationItem.leftBarButtonItem = backButton
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadWebPage() {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        ProgressHUD.show()
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        ProgressHUD.dismiss()
    }
}
