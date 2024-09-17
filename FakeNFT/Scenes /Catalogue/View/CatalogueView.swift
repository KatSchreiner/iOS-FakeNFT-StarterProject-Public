import UIKit

// MARK: - CatalogueViewProtocol
protocol CatalogueViewProtocol: AnyObject {
    func setTableViewDelegate(_ delegate: UITableViewDelegate)
    func setTableViewDataSource(_ dataSource: UITableViewDataSource)
    func endRefreshing()
    func addRefreshTarget(_ target: Any?, action: Selector)
    func updateTable(
        deletedRows: [IndexPath],
        insertedRows: [IndexPath],
        reloadedRows: [IndexPath],
        completion: ((Bool) -> Void)?
    )
    func deselectRow(indexPath: IndexPath, animated: Bool)
}

// MARK: - CatalogueView
final class CatalogueView: UIView, CatalogueViewProtocol {
    
    // MARK: View
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "YP White")
        tableView.separatorStyle = .none
        tableView.register(CatalogueCell.self, forCellReuseIdentifier: "CatalogueCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Private methods
    
    private func setupView() {
        addSubview(tableView)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    // MARK: - CatalogueViewProtocol Methods
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func addRefreshTarget(_ target: Any?, action: Selector) {
        refreshControl.addTarget(target, action: action, for: .valueChanged)
    }
    
    func updateTable(deletedRows: [IndexPath], insertedRows: [IndexPath], reloadedRows: [IndexPath], completion: ((Bool) -> Void)?) {
        tableView.performBatchUpdates({
            if !deletedRows.isEmpty {
                tableView.deleteRows(at: deletedRows, with: .automatic)
            }
            if !insertedRows.isEmpty {
                tableView.insertRows(at: insertedRows, with: .automatic)
            }
            if !reloadedRows.isEmpty {
                tableView.reloadRows(at: reloadedRows, with: .automatic)
            }
        }, completion: completion)
    }
    
    func deselectRow(indexPath: IndexPath, animated: Bool) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
