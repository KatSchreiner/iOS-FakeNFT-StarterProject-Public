import UIKit

 // MARK: - CatalogueView

 class CatalogueView: UIView {

     // MARK: View
     let tableView: UITableView = {
         let tableView = UITableView()
         tableView.backgroundColor = UIColor(named: "YP White")
         tableView.separatorStyle = .none
         tableView.register(CatalogueCell.self, forCellReuseIdentifier: "CatalogueCell")
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
     
     let refreshControl: UIRefreshControl = {
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
 }
