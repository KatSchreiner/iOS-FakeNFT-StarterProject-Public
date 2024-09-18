//
//  MyNFTsViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 11.09.2024.
//

import UIKit
import ProgressHUD

final class MyNftViewController: UIViewController {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    private var nfts: [NftList] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: "NFTCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var backButton: BackButton = {
        let backButton = BackButton(target: self, action: #selector(didTapBack))
        return backButton
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sort")
        button.tintColor = .nBlack
        button.action = #selector(didTapSort)
        button.target = self
        return button
    }()
    
    private lazy var noNftLabel: UILabel = {
        let noNftLabel = UILabel()
        noNftLabel.font = .bodyBold
        noNftLabel.textColor = .nBlack
        return noNftLabel
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly, nfts: [NftList]) {
        self.servicesAssembly = servicesAssembly
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchNfts()
    }
    // MARK: - IB Actions
    @objc
    private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapSort() {
        let alertController = UIAlertController(title: "Сортировка", message: "", preferredStyle: .actionSheet)
        
        let priceSortAction = UIAlertAction(title: "По цене", style: .default) { _ in
            self.sortNfts(by: { $0.price < $1.price })
        }
        
        let ratingSortAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.sortNfts(by: { $0.rating > $1.rating })
        }
        
        let nameSortAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.sortNfts(by: { $0.name < $1.name })
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(priceSortAction)
        alertController.addAction(ratingSortAction)
        alertController.addAction(nameSortAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Мои NFT"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortButton
        
        [tableView, noNftLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraint()
        
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            
            noNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchNfts() {
        ProgressHUD.show()
        servicesAssembly.nftListInstanse.fetchNfts { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                    self.tableView.reloadData()
                    self.noNftLabel.isHidden = !self.nfts.isEmpty
                    self.tableView.isHidden = self.nfts.isEmpty
                case .failure(let error):
                    print("Ошибка при получении NFT: \(error)")
                }
            }
        }
    }
    
    private func sortNfts(by comparator: @escaping (NftList, NftList) -> Bool) {
        ProgressHUD.show()
        DispatchQueue.global().async {
            self.nfts.sort(by: comparator)
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITabvleViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCell", for: indexPath) as? MyNftTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = nfts[indexPath.row]
        cell.configure(with: nft)
        
        return cell
        
    }
}

// MARK: - UITabvleViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
