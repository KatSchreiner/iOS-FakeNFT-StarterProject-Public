import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly
    
    private let profileTabBarItem = UITabBarItem(
        title: ("Tab.profile".localized()),
        image: UIImage(named: "profile_tb"),
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

        let statisticsView = StatisticsView()
        let statisticsViewController = StatisticsViewController(statisticsService: StatisticsService.shared, statisticsView: statisticsView)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
       
        let basketController = BasketViewController(servicesAssembly: servicesAssembly)

        profileVC.tabBarItem = profileTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsNavigationController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileController, basketController, statisticsNavigationController]
    }
}
