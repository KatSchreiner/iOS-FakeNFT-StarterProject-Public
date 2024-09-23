
import UIKit
protocol CollectionRouterProtocol {
    func navigateToWebViewController(from viewController: UIViewController, url: URL)
}

final class CollectionRouter: CollectionRouterProtocol {
    
    func navigateToWebViewController(from viewController: UIViewController, url: URL) {
        let webViewController = WebViewController(url: url)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        viewController.navigationItem.backBarButtonItem = backButton
        viewController.navigationController?.navigationBar.tintColor = .black
        
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }
}
