import UIKit
import ProgressHUD

// MARK: - CatalogueViewController

final class CatalogueViewController: UIViewController {
    
    // MARK: Properties
    private let filterStorage: FilterStorageProtocol
    private let catalogueView: CatalogueViewProtocol
    private let catalogueService: CatalogueServiceProtocol
    var router: CatalogueRouterProtocol!
    private var collections: [NFTCollections] = []
    
    // MARK: Initialization
    init(catalogueView: CatalogueViewProtocol,
         catalogueService: CatalogueServiceProtocol,
         filterStorage: FilterStorageProtocol
    ) {
        self.catalogueView = catalogueView
        self.catalogueService = catalogueService
        self.filterStorage = filterStorage
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = catalogueView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchCollections()
    }
    
    // MARK: Setup View
    private func setupView() {
        catalogueView.setTableViewDelegate(self)
        catalogueView.setTableViewDataSource(self)
        catalogueView.addRefreshTarget(self, action: #selector(refreshData))
    }
    
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
        rightButton.tintColor = UIColor(named: "YP Black")
        navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: Data Fetching
    private func fetchCollections() {
        ProgressHUD.show()
        let oldCollections = collections
        catalogueService.fetchCollections { [weak self] result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success(let newCollections):
                    self?.collections = newCollections
                    self?.updateTableViewAnimated(oldCollections: oldCollections)
                    self?.loadFilter()
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
        }
    }
    
    // MARK: Actions
    @objc private func sortTapped() {
        router.presentSortOptions(
            sortByNameAction: { [weak self] in
                self?.sortByName()
                self?.filterStorage.saveFilter(.name)
            },
            sortByAmountAction: { [weak self] in
                self?.sortByAmount()
                self?.filterStorage.saveFilter(.amount)
            }
        )
    }
    
    @objc private func refreshData() {
        fetchCollections()
        catalogueView.endRefreshing()
    }
    
    // MARK: Data sorting
    private func loadFilter() {
        let savedFilter = filterStorage.loadFilter()
        
        switch savedFilter {
        case .amount:
            sortByAmount()
        case .name:
            sortByName()
        }
    }
    
    private func sortByAmount() {
        let oldCollections = collections
        collections.sort { $0.nfts.count < $1.nfts.count }
        updateTableViewAnimated(oldCollections: oldCollections)
    }

    private func sortByName() {
        let oldCollections = collections
        collections.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        updateTableViewAnimated(oldCollections: oldCollections)
    }
    
    // MARK: Table View Updates
    private func updateTableViewAnimated(oldCollections: [NFTCollections]) {
        let newCollections = collections
        
        let oldIndexPaths = oldCollections.indices.map { IndexPath(row: $0, section: 0) }
        let newIndexPaths = newCollections.indices.map { IndexPath(row: $0, section: 0) }
        
        let insertedIndexPaths = newIndexPaths.filter { !oldIndexPaths.contains($0) }
        let deletedIndexPaths = oldIndexPaths.filter { !newIndexPaths.contains($0) }
        let reloadedIndexPaths = newIndexPaths.filter { oldIndexPaths.contains($0) }
        
        catalogueView.updateTable(
            deletedRows: deletedIndexPaths,
            insertedRows: insertedIndexPaths,
            reloadedRows: reloadedIndexPaths,
            completion: nil
        )
    }
}

// MARK: - UITableViewDelegate
extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        catalogueView.deselectRow(indexPath: indexPath, animated: true)
        
        if collections.indices.contains(indexPath.row) {
            let nfts = collections[indexPath.row].nfts
            let newViewControllerClient = DefaultNetworkClient()
            let newViewControllerService = CatalogueService(networkClient: newViewControllerClient)

            router.navigateToDetail(with: nfts, catalogueService: newViewControllerService)
   
        } else {
            print("⚠️ Индекс вне диапазона.")
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension CatalogueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogueCell", for: indexPath) as? CatalogueCell else {
            return UITableViewCell()
        }
        
        if collections.indices.contains(indexPath.row) {
            let cellData = collections[indexPath.row]
            let name = "\(cellData.name) (\(cellData.nfts.count))"
            let imageURL = cellData.cover
            
            cell.configure(name: name, imageURL: imageURL) { result in
                switch result {
                case .success:
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure:
                    print("⚠️ Не удалось загрузить изображение")
                    return
                }
            }
        } else {
            print("⚠️ Индекс вне диапазона.")
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
}
