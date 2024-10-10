import UIKit
import ProgressHUD

// MARK: CollectionViewController
final class CollectionViewController: UIViewController {
    
    // MARK: Properties
    private let collectionView: CollectionViewProtocol
    private let collectionService: CatalogueServiceProtocol
    private var router: CollectionRouterProtocol
    private let urlToOpen = "https://practicum.yandex.ru/ios-developer/"
    private let collection: CatalogueNFTCollection
    private var nftsList: [NFT] = []
    private var cart: [String]?
    private var likes: [String]?
    private let dispatchGroup = DispatchGroup()
    
    // MARK: Initialization
    init(with collection: CatalogueNFTCollection,
         service: CatalogueService,
         view: CollectionViewProtocol,
         router: CollectionRouterProtocol
    ) {
        self.collectionView = view
        self.collection = collection
        self.collectionService = service
        self.router = router
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.delegate = self
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = collectionView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    // MARK: Setup View
    private func setupView() {
        collectionView.setCollectionViewDataSource(self)
        collectionView.setCollectionViewDelegate(self)
        collectionView.register(cellType: CollectionCell.self, reuseIdentifier: CollectionCell.identifier)
    }
    
    // MARK: Data Fetching
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchAllNFTs { _ in
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchCart { _ in
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchUserProfile { _ in
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.updateUI()
        }
    }
    
    private func fetchAllNFTs(completion: @escaping (Bool) -> Void) {
        collectionService.fetchAllNFTs(for: collection.nfts) { [weak self] result in
            guard let self = self else { return completion(false) }
            
            switch result {
            case .success(let nfts):
                self.nftsList = nfts
                completion(true)
            case .failure(let error):
                print("⚠️ Ошибка загрузки NFTs: \(error)")
                completion(false)
            }
        }
    }
    
    private func fetchCart(completion: @escaping (Bool) -> Void) {
        collectionService.fetchCart { [weak self] result in
            guard let self = self else { return completion(false) }
            
            switch result {
            case .success(let cart):
                self.cart = cart.nfts
                completion(true)
            case .failure(let error):
                print("⚠️ Ошибка загрузки корзины: \(error)")
                completion(false)
            }
        }
    }
    
    private func fetchUserProfile(completion: @escaping (Bool) -> Void) {
        collectionService.fetchUserProfile { [weak self] result in
            guard let self = self else { return completion(false) }
            
            switch result {
            case .success(let user):
                self.likes = user.likes
                completion(true)
            case .failure(let error):
                print("⚠️ Ошибка загрузки профиля: \(error)")
                completion(false)
            }
        }
    }
    
    // MARK: View Updates
    private func updateUI() {
        self.collectionView.configureView(with: self.collection)
        self.collectionView.reloadData()
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        let nft = nftsList[indexPath.row]
        cell.configure(with: nft, cart: cart ?? [""], likes: likes ?? [""])
        cell.delegate = self
        return cell
    }
}

// MARK: - Extension UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 9
    }
}

//MARK: - CollectionCellDelegate
extension CollectionViewController: CollectionCellDelegate {
    func cartButtonClicked(nft: String) {
        guard let cart else { return }
        UIBlockingProgressHUD.show()
        collectionService.updateCart(with: nft, in: cart) { result in
            switch result {
            case .success(let result):
                self.cart = result.nfts
            case .failure(let error):
                print("⚠️ Ошибка при обновлении корзины: \(error)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func likeButtonClicked(nft: String) {
        guard let likes else { return }
        UIBlockingProgressHUD.show()
        collectionService.updateLike(with: nft, in: likes) { result in
            switch result {
            case .success(let result):
                self.likes = result.likes
            case .failure(let error):
                print("⚠️ Ошибка при обновлении лайков: \(error)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

//MARK: - CollectionCellDelegate
extension CollectionViewController: CollectionViewDelegate {
    func didTapAuthorLabel() {
        guard let url = URL(string: urlToOpen) else { return }
        router.navigateToWebViewController(from: self, url: url)
    }
}
