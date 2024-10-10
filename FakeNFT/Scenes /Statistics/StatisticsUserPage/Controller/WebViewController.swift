import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController & WKNavigationDelegate {
    
    // MARK: - Private Properties
    private var urlRequest: URLRequest
    private var observation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.setProgress(0.0, animated: false)
        return progressView
    }()
    
    // MARK: - Initializers
    init(url: String) {
        guard let url = URL(string: url) else {
            fatalError("URL is nil")
        }
        urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observation = webView.observe(\WKWebView.estimatedProgress, options: .new) { _, change in
            DispatchQueue.main.async { [weak self] in
                let progressValue = fabs(change.newValue ?? 0.0)
                self?.progressView.progress = Float(progressValue)
                
                if progressValue >= 0.0001 {
                    ProgressHUD.dismiss()
                }
            }
        }
        urlRequest.timeoutInterval = TimeInterval(5)
        webView.load(urlRequest)
        ProgressHUD.show()
    }
    
    // MARK: - WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                showAlertAndPop(withMessage: "Не удалось получить данные")
            } else {
                showAlertAndPop(withMessage: "\(error.localizedDescription)")
            }
        }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showAlertAndPop(withMessage: "\(error.localizedDescription)")
    }
    
    
    // MARK: - Private methods
    private func addSubviews(){
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func showAlertAndPop(withMessage message: String) {
        ProgressHUD.dismiss()
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
               self?.navigationController?.popViewController(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            urlRequest.timeoutInterval = TimeInterval(5)
            webView.load(urlRequest)
            ProgressHUD.show()
        }
        
        alertController.addAction(repeatAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Deinitialization
    deinit {
        observation?.invalidate()
        observation = nil
    }
}
