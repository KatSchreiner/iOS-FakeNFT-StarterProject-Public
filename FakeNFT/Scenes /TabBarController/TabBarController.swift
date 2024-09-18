import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogueTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalogue", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogueView = CatalogueView()
        let catalogueService = CatalogueService(networkClient: DefaultNetworkClient())
        let catalogueViewController = CatalogueViewController(catalogueView: catalogueView, catalogueService: catalogueService)
        let catalogueNavigationController = UINavigationController(rootViewController: catalogueViewController)
        
        catalogueViewController.tabBarItem = catalogueTabBarItem
        viewControllers = [catalogueNavigationController]
        view.backgroundColor = .systemBackground
    }
}
