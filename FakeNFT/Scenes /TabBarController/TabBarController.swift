import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogueTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogueView = CatalogueView()
        let networkClient = DefaultNetworkClient()
        let catalogueService = CatalogueService(networkClient: networkClient)
        let filterStorage = FilterStorage()
        
        let catalogueViewController = CatalogueViewController(
            catalogueView: catalogueView,
            catalogueService: catalogueService,
            filterStorage: filterStorage
        )
        
        let catalogueRouter = CatalogueRouter(viewController: catalogueViewController)
        catalogueViewController.router = catalogueRouter
        
        let catalogueNavigationController = UINavigationController(rootViewController: catalogueViewController)
        
        catalogueViewController.tabBarItem = catalogueTabBarItem
        viewControllers = [catalogueNavigationController]
        view.backgroundColor = .systemBackground
    }
}
