import UIKit

// MARK: - CatalogueRouterProtocol
protocol CatalogueRouterProtocol {
    func navigateToDetail(with nfts: [String], service: CatalogueService, view: CollectionView)
    func presentSortOptions(
        sortByNameAction: @escaping () -> Void,
        sortByAmountAction: @escaping () -> Void
    )
}

// MARK: - CatalogueRouter
final class CatalogueRouter: CatalogueRouterProtocol {
    
    // MARK: Properties
    weak var viewController: UIViewController?
    
    // MARK: Initialization
    init() {}
    
    // MARK: Public functions
    func navigateToDetail(with nfts: [String], service: CatalogueService, view: CollectionView) {
        
        guard let viewController else { return }
        
        let controller = CollectionViewController(nfts: nfts, service: service, view: view)
        configureNavigationBar(for: viewController) 
        
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentSortOptions(
        sortByNameAction: @escaping () -> Void,
        sortByAmountAction: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            sortByNameAction()
        }
        
        let sortByAmountAction = UIAlertAction(title: "По количеству NFT", style: .default) { _ in
            sortByAmountAction()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByAmountAction)
        alert.addAction(cancelAction)
        
        guard let viewController else { return }
        viewController.present(alert, animated: true)
    }
    
    // Отдельный метод для настройки NavigationBar
    private func configureNavigationBar(for viewController: UIViewController) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        viewController.navigationItem.backBarButtonItem = backButton
        viewController.navigationController?.navigationBar.tintColor = .black
    }
}
