import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly
    
    private let catalogueTabBarItem = UITabBarItem(
        title: ("Tab.catalog".localized()),
        image: UIImage(systemName: "square.stack.fill"),
        tag: 1
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: ("Tab.profile".localized()),
        image: UIImage(named: "profile_tb"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: ("Tab.basket".localized()),
        image: UIImage(named: "Tab.basket"),
        tag: 2
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: ("Tab.statistic".localized()),
        image: UIImage(named: "statistics_tb"),
        tag: 3
    )

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupView()
        configureTabs()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .nBlack
    }
    
    private func configureTabs() {
        let profileVC = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileController = UINavigationController(rootViewController: profileVC)
        profileController.tabBarItem = profileTabBarItem
        
        let statisticsView = StatisticsView()
        let statisticsViewController = StatisticsViewController(statisticsService: StatisticsService.shared, statisticsView: statisticsView)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
        let basketController = BasketViewController(servicesAssembly: servicesAssembly)
        let basketNavigationController = UINavigationController(rootViewController: basketController)
        basketNavigationController.tabBarItem = basketTabBarItem
        
        let catalogueView = CatalogueView()
        let networkClient = DefaultNetworkClient()
        let catalogueService = CatalogueService(networkClient: networkClient)
        let filterStorage = FilterStorage()
        let catalogueRouter = CatalogueRouter()
        
        let catalogueViewController = CatalogueViewController(
            catalogueView: catalogueView,
            catalogueService: catalogueService,
            filterStorage: filterStorage,
            router: catalogueRouter
        )
        
        let catalogueNavigationController = UINavigationController(rootViewController: catalogueViewController)
        catalogueNavigationController.tabBarItem = catalogueTabBarItem
        
        viewControllers = [
            profileController,
            catalogueNavigationController,
            basketNavigationController,
            statisticsNavigationController
        ]
    }
}
