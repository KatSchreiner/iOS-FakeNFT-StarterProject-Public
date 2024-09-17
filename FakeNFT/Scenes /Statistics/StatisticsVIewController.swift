import UIKit

final class StatisticsViewController: UIViewController, UITableViewDelegate {
    private let userData: [(name: String, rating: String, imageUrl: String)] = [
            (name: "Alex", rating: "122", imageUrl: "https://example.com/image1.jpg"),
            (name: "Jordan", rating: "95", imageUrl: "https://example.com/image2.jpg")
        ]
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "StatisticsTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        return tableView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sort_button"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .black
        return sortButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = nil
        navigationItem.rightBarButtonItem = sortButton
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func sortButtonTapped() {
        //showAlert()
    }
}


extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsTableViewCell", for: indexPath)
        guard let statisticsCell = cell as? StatisticsTableViewCell else {
            assertionFailure("Cell is null for statisticsViewController")
            return UITableViewCell()
        }
        let user = userData[indexPath.row]
        statisticsCell.configureCell(index: String(indexPath.row+1), name: user.name, rating: user.rating, url: user.imageUrl)
        return statisticsCell
    }
}
