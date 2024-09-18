import UIKit

protocol StatisticsUserPageViewDelegate: AnyObject {
    func didTapOpenWebView()
    func didTapOpenNFTCollection()
}


final class StatisticsUserPageViewController: UIViewController {
    // MARK: - Private Properties
    private let statisticsUserPageView: StatisticsUserPageView
    
    // MARK: - Initializers
    init(statisticsUserPageView: StatisticsUserPageView = StatisticsUserPageView()) {
        self.statisticsUserPageView = statisticsUserPageView
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
    }
    
    
}


// MARK: - StatisticsUserPageViewDelegate
extension StatisticsUserPageViewController: StatisticsUserPageViewDelegate {
    func didTapOpenWebView() {
        print("User tapped on 'Open Web View' button")
    }
    
    func didTapOpenNFTCollection() {
        print("User tapped on 'Open NFT Collection' button")
    }
}
