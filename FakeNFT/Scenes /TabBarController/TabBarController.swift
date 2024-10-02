import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.basket", comment: ""),
        image: UIImage(named: "Tab.basket"),
        tag: 1
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
        let statisticsView = StatisticsView()
        let statisticsViewController = StatisticsViewController(statisticsService: StatisticsService.shared, statisticsView: statisticsView)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        let basketController = BasketViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        viewControllers = [catalogController, basketController, statisticsNavigationController]
        view.backgroundColor = .systemBackground
    }
}
