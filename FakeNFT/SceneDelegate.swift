import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileService: ProfileService(), 
        updateProfile: UpdateProfileService(networkClient: DefaultNetworkClient()),
        nftList: NftListService(),
        favoritesService: FavoritesService()
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = scene as? UIWindowScene else { return }
         
         window = UIWindow(windowScene: windowScene)
         let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
         tabBarController.servicesAssembly = servicesAssembly
         
         window?.rootViewController = tabBarController
         window?.makeKeyAndVisible()
     }
}
