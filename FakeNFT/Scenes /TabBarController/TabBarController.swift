import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogViewController = CatalogueViewController()
        let catalogNavigationController = UINavigationController(
            rootViewController: catalogViewController
        )
        
        catalogViewController.tabBarItem = catalogTabBarItem
        viewControllers = [catalogNavigationController]
        view.backgroundColor = .systemBackground
    }
}
