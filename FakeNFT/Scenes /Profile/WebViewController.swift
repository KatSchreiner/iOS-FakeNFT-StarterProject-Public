//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Public Properties
    var urlString: String?
    
    // MARK: - Private Properties
    private var webView: WKWebView!
    
    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = .nBlack
        backButton.image = UIImage(systemName: "chevron.left")
        return backButton
    }()
    
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
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
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
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
