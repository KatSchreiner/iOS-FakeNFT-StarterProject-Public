import UIKit
import ProgressHUD

// MARK: CatalogueViewController

final class CatalogueViewController: UIViewController {
    
    // MARK: Properties
    private var collections: [NFTCollection] = []
    private var sortedByNameAscending = false
    private var sortedByAmountAscending = false

    private var catalogView: CatalogueView {
        return self.view as! CatalogueView
    }
    
    // MARK: - Initialization
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = CatalogueView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchCollections()
    }

    // MARK: - Setup View
    private func setupView() {
        catalogView.tableView.delegate = self
        catalogView.tableView.dataSource = self
        catalogView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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

    // MARK: - Data Fetching
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

    // MARK: - Actions
    @objc private func sortTapped() {
    }

    @objc private func refreshData() {
        fetchCollections()
        catalogView.refreshControl.endRefreshing()
    }

    // MARK: Table View Updates
    private func updateTableViewAnimated(oldCollections: [NFTCollection]) {
        let newCollections = collections

        let oldIndexPaths = oldCollections.indices.map { IndexPath(row: $0, section: 0) }
        let newIndexPaths = newCollections.indices.map { IndexPath(row: $0, section: 0) }

        let insertedIndexPaths = newIndexPaths.filter { !oldIndexPaths.contains($0) }
        let deletedIndexPaths = oldIndexPaths.filter { !newIndexPaths.contains($0) }
        let reloadedIndexPaths = newIndexPaths.filter { oldIndexPaths.contains($0) }

        catalogView.tableView.performBatchUpdates {
            if !deletedIndexPaths.isEmpty {
                catalogView.tableView.deleteRows(at: deletedIndexPaths, with: .automatic)
            }
            if !insertedIndexPaths.isEmpty {
                catalogView.tableView.insertRows(at: insertedIndexPaths, with: .automatic)
            }
            if !reloadedIndexPaths.isEmpty {
                catalogView.tableView.reloadRows(at: reloadedIndexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        catalogView.tableView.deselectRow(at: indexPath, animated: true)
        
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
