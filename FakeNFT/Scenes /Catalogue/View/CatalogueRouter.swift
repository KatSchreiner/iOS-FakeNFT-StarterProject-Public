import UIKit

// MARK: - CatalogueRouterProtocol
protocol CatalogueRouterProtocol {
    func navigateToDetail(with nfts: [String], catalogueService: CatalogueService)
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
    func navigateToDetail(with nfts: [String], catalogueService: CatalogueService) {
        let controller = CollectionViewController(nfts: nfts, catalogueService: catalogueService)
        viewController?.navigationController?.pushViewController(controller, animated: true)
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
        
        viewController?.present(alert, animated: true)
    }
}
