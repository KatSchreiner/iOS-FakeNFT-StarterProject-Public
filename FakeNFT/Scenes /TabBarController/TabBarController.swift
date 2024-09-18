import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "statistics_tb"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statisticsViewController = StatisticsViewController(statisticsService: StatisticsService.shared)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        catalogController.tabBarItem = catalogTabBarItem
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        viewControllers = [catalogController, statisticsNavigationController]

        view.backgroundColor = .systemBackground
    }
}
