import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    private var userData: [Statistics] = []
    private let statisticsService: StatisticsServiceProtocol
    private let statisticsView: StatisticsViewProtocol
    
    // MARK: - Initializers
    init(statisticsService: StatisticsServiceProtocol, statisticsView: StatisticsViewProtocol) {
        self.statisticsService = statisticsService
        self.statisticsView = statisticsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = statisticsView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        getUsers()
    }
    
    // MARK: - Setup View
    private func setupView() {
        statisticsView.setTableViewDelegate(self)
        statisticsView.setTableViewDataSource(self)
    }
    
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(
            image: UIImage(named: "sort_button"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        rightButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    // MARK: - Data Fetching
    private func getUsers(){
        view.isUserInteractionEnabled = false
        ProgressHUD.show()
        statisticsService.fetchStatistics { [weak self] result in
            self?.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.userData = users
            case .failure(let error):
                print(error.localizedDescription)
            }
            statisticsView.updateTable()
        }
    }
    
    // MARK: - Actions
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По имени", style: .default, handler: { [weak self] _ in
            self?.userData.sort(by: { $0.name < $1.name })
            self?.statisticsView.updateTable()
        }))
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] _ in
            self?.userData.sort(by: { $0.nfts.count > $1.nfts.count })
            self?.statisticsView.updateTable()
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { _ in
            print("User click to cancel action sheet")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath)
        guard let statisticsCell = cell as? StatisticsTableViewCell else {
            assertionFailure("Cell is null for statisticsViewController")
            return UITableViewCell()
        }
        let user = userData[indexPath.row]
        statisticsCell.configureCell(with: StatisticsModel(index: String(indexPath.row+1), name: user.name, rating: String(user.nfts.count), imageUrl: user.avatar))
        return statisticsCell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statisticsView.deselectRow(indexPath: indexPath, animated: true)
        let user = userData[indexPath.row]
        let userViewController = StatisticsUserPageViewController(userId: user.id)
        userViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(userViewController, animated: true)
    }
}
