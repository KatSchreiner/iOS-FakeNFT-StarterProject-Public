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
    var profile: Profile?
    var nfts: [NFT] = []
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: "NFTCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
        noNftLabel.text = "У Вас ещё нет NFT"
        return noNftLabel
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
            self.sortNFTs(by: .price)
        }
        
        let ratingSortAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.sortNFTs(by: .rating)
        }
        
        let nameSortAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.sortNFTs(by: .name)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(priceSortAction)
        alertController.addAction(ratingSortAction)
        alertController.addAction(nameSortAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
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
        updateNoNftLabelVisibility()
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
    
    private func updateNoNftLabelVisibility() {
        noNftLabel.isHidden = !nfts.isEmpty
    }
    
    private func sortNFTs(by criteria: SortCriteria) {
        ProgressHUD.show()
        
        switch criteria {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
        
        tableView.reloadData()
        ProgressHUD.dismiss()
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
        guard let profile = profile else {
            print("[MyNftViewController:cellForRowAt]: Профиль не найден, не удается настроить ячейку.")
            return cell
        }
        cell.configure(with: nft, profile: profile)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITabvleViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - MyNftCellLikeDelegate
extension MyNftViewController: MyNftCellLikeDelegate {
    func didUpdateFavoriteStatus(isLiked: Bool, for nftId: String, profileId: String) {
        FavoritesService().updateFavoriteNft(profileId: profileId, nftId: nftId, isLiked: isLiked) { [weak self] result in
            switch result {
            case .success:
                self?.updateProfileLikes(isLiked: isLiked, nftId: nftId)
            case .failure(let error):
                print("[MyNftViewController:didUpdateFavoriteStatus]: Ошибка при \(isLiked ? "добавлении" : "удалении") из избранного: \(error)")
            }
        }
    }
    
    private func updateProfileLikes(isLiked: Bool, nftId: String) {
        guard var profile = profile else { return }
        
        if isLiked {
            profile.likes.append(nftId)
        } else {
            profile.likes.removeAll { $0 == nftId }
        }
        
        updateProfileOnServer(with: profile)
    }
    
    private func updateProfileOnServer(with profile: Profile) {
        let likesProfile = FavoritesService(networkClient: DefaultNetworkClient())
        
        likesProfile.updateLikesProfile(likes: profile.likes) { result in
            switch result {
            case .success(let updateLikesProfile):
                self.profile = updateLikesProfile
                self.tableView.reloadData()
                print("[MyNftViewController:updateProfileOnServer]: Список favoriteNft успешно обновлен: \(profile.likes)")
            case .failure(let error):
                print("[MyNftViewController:updateProfileOnServer]: Ошибка при обновлении favoriteNft: \(error.localizedDescription)")
            }
        }
    }
}

enum SortCriteria {
    case price
    case rating
    case name
}
