//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 11.09.2024.
//

import UIKit

final class FavoriteNftViewController: UIViewController {
    // MARK: - Public Properties
    var profile: Profile?
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    
    private var likedNfts: [NFT] = []
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "favoriteCell")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var backButton: BackButton = {
        return BackButton(target: self, action: #selector(didTapBack))
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
        loadLikedNfts()
    }
    
    // MARK: - IB Actions
    @objc
    private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Избранные NFT"
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadLikedNfts() {
        guard let profile = profile else {
            print("[FavoriteNftViewController:loadLikedNfts]: Профиль не инициализирован.")
            return
        }
        
        let ids = profile.likes
        print("[FavoriteNftViewController:loadLikedNfts]: Загрузка избранных NFT с ID: \(ids)")
        
        servicesAssembly.nftListInstanse.fetchNfts { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.likedNfts = nfts.filter { ids.contains($0.id) }
                print("[FavoriteNftViewController:loadLikedNfts]: Получены избранные NFT: \(self?.likedNfts ?? [])")
                self?.collection.reloadData()
            case .failure(let error):
                print("[FavoriteNftViewController:loadLikedNfts]: Ошибка получения избранных NFT: \(error)")
            }
        }
    }
    
    func removeNftFromFavorites(nftId: String) {
        print("[FavoriteNftViewController:removeNftFromFavorites]: Удаляем из избранного NFT с ID: \(nftId)")
        guard var profile = profile else { return }
        
        profile.likes.removeAll() { $0 == nftId }
        
        servicesAssembly.favoritesServiceInstanse.updateFavoriteNft(profileId: profile.id, nftId: nftId, isLiked: false) { [weak self] result in
           
            switch result {
            case .success:
                self?.likedNfts.removeAll { $0.id == nftId }
                self?.collection.reloadData()
                print("[FavoriteNftViewController:removeNftFromFavorites]: NFT успешно удален из избранного: \(nftId)")
            case .failure(let error):
                print("[FavoriteNftViewController:removeNftFromFavorites]: Ошибка при удалении NFT из избранного: \(error)")
            }
        }
        
        if !profile.likes.isEmpty {
            updateProfileOnServer(with: profile)
        } else {
            print("[FavoriteNftViewController:removeNftFromFavorites]: Список likes пуст, обновление профиля не требуется.")
        }
    }
    
    private func updateProfileOnServer(with profile: Profile) {
        let likesProfile = FavoritesService(networkClient: DefaultNetworkClient())
        
        likesProfile.updateLikesProfile(likes: profile.likes) { result in
            switch result {
            case .success(let updateLikesProfile):
                self.profile = updateLikesProfile
                self.collection.reloadData()
                print("[FavoriteNftViewController:updateProfileOnServer]: Список favoriteNft успешно обновлен: \(profile.likes)")
            case .failure(let error):
                print("[FavoriteNftViewController:updateProfileOnServer]: Ошибка при обновлении favoriteNft: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UIUICollectionViewDataSource
extension FavoriteNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedNfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        
        let nft = likedNfts[indexPath.item]
        guard let profile = profile else {
            print("[FavoriteNftViewController:cellForItemAt]: Профиль не найден, не удается настроить ячейку.")
            return cell
        }
        
        cell.configure(with: nft, profile: profile)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension FavoriteNftViewController: FavoriteCellDelegate {
    func didTapRemoveFromFavorites(nftId: String) {
        removeNftFromFavorites(nftId: nftId)
    }
}
