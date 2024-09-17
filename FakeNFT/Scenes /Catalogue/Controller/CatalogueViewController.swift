import UIKit
import ProgressHUD

// MARK: CatalogueViewController

final class CatalogueViewController: UIViewController {
    
    // MARK: Properties
    private let catalogView: CatalogueViewProtocol
    private var collections: [NFTCollection] = []
    private var sortedByNameAscending = false
    private var sortedByAmountAscending = false
    
    // MARK: - Initialization
    init(catalogView: CatalogueViewProtocol) {
        self.catalogView = catalogView
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = catalogView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchCollections()
    }
    
    // MARK: Setup View
    private func setupView() {
        catalogView.setTableViewDelegate(self)
        catalogView.setTableViewDataSource(self)
        catalogView.addRefreshTarget(self, action: #selector(refreshData))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            print("Данные загружены")
            ProgressHUD.dismiss()
            self?.collections = CollectionMockData.collections
            self?.updateTableViewAnimated(oldCollections: oldCollections)
        }
    }
    
    // MARK: Actions
    @objc private func sortTapped() {
    }
    
    @objc private func refreshData() {
        fetchCollections()
        catalogView.endRefreshing()
        //catalogView.refreshControl.endRefreshing()
    }
    
    // MARK: Table View Updates
    private func updateTableViewAnimated(oldCollections: [NFTCollection]) {
        let newCollections = collections
        
        let oldIndexPaths = oldCollections.indices.map { IndexPath(row: $0, section: 0) }
        let newIndexPaths = newCollections.indices.map { IndexPath(row: $0, section: 0) }
        
        let insertedIndexPaths = newIndexPaths.filter { !oldIndexPaths.contains($0) }
        let deletedIndexPaths = oldIndexPaths.filter { !newIndexPaths.contains($0) }
        let reloadedIndexPaths = newIndexPaths.filter { oldIndexPaths.contains($0) }
        
        catalogView.updateTable(
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
        catalogView.deselectRow(indexPath: indexPath, animated: true)
        
        if collections.indices.contains(indexPath.row) {
            let detailVC = NewViewController()
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("⚠️ Индекс вне диапазона.")
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
                    print("Не удалось загрузить изображение")
                }
            }
        } else {
            print("⚠️ Индекс вне диапазона.")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
}
