import UIKit
import ProgressHUD
import Kingfisher

protocol StatisticsUserPageViewDelegate: AnyObject {
    func didTapOpenWebView()
    func didTapOpenNFTCollection()
}

final class StatisticsUserPageViewController: UIViewController {
    
    // MARK: - Private Properties
    private let statisticsUserPageView: StatisticsUserPageView
    private let statisticsUserService: StatisticsUserNetworkService
    private let userId: String
    private var user: Statistics?
    
    // MARK: - Initializers
    init(userId: String, statisticsUserPageView: StatisticsUserPageView = StatisticsUserPageView()) {
        self.statisticsUserPageView = statisticsUserPageView
        self.statisticsUserService = StatisticsUserNetworkService.shared
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = statisticsUserPageView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        statisticsUserPageView.delegate = self
        getSingleUserProfile(userId: self.userId)
    }
    
    // MARK: - Private methods
    private func configure(with user: Statistics?) {
        guard let user = self.user else {
            return
        }
        statisticsUserPageView.configure(with: user)
    }
    
    
    // MARK: - Data Fetching
    private func getSingleUserProfile(userId: String){
        view.isUserInteractionEnabled = false
        ProgressHUD.show()
        statisticsUserService.fetchUser(userId: userId, completion: { [weak self] result in
            self?.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.configure(with: user)
            case .failure(let error):
                print("Error: \(error)")
            }
        })
        
    }
}


// MARK: - StatisticsUserPageViewDelegate
extension StatisticsUserPageViewController: StatisticsUserPageViewDelegate {
    func didTapOpenWebView() {
        guard let user = self.user else { return }
        print("User website for \(user.name) is \(user.website) and his id is \(user.id)")
        let webView = WebViewController(url: user.website)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func didTapOpenNFTCollection() {
        
    }
}
