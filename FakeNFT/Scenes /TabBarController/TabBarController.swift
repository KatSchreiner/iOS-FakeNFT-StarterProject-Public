import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "profile_tb"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTabs()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .primary
        tabBar.unselectedItemTintColor = .nBlack
    }
    
    private func configureTabs() {
        let profileVC = ProfileViewController()
        let profileController = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [profileController]
    }
}
