import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly
    
    private let profileTabBarItem = UITabBarItem(
        title: ("Tab.profile".localized()),
        image: UIImage(named: "profile_tb"),
        tag: 0
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
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [profileController]
    }
}
