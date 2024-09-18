import UIKit

// MARK: - StatisticsViewProtocol
protocol StatisticsViewProtocol: AnyObject {
    func setTableViewDelegate(_ delegate: UITableViewDelegate)
    func setTableViewDataSource(_ dataSource: UITableViewDataSource)
    func deselectRow(indexPath: IndexPath, animated: Bool)
    func updateTable() 
}

final class StatisticsView: UIView, StatisticsViewProtocol {
    // MARK: View
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "StatisticsTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        return tableView
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    // MARK: - StatisticsViewProtocol Methods
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func deselectRow(indexPath: IndexPath, animated: Bool) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}
