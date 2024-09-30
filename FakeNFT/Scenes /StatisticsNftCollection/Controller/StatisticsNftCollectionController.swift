import UIKit
import ProgressHUD

final class StatisticsNftCollectionController: UIViewController {
    // MARK: - Private Properties
    private let statisticsNftView: StatisticsNftViewProtocol
    private let statisticsNftService: StatisticsNftsService
    private var nftIds: [String]?
    private var cart: [String]?
    private var likes: [String]?
    private var nfts: [NftById] {
        didSet {
            statisticsNftView.updateCollection()
        }
    }
    
    // MARK: - Initializers
    init(nfts: [String]?, statisticsNftView: StatisticsNftViewProtocol = StatisticsNftView()) {
        self.nftIds = nfts
        self.nfts = []
        self.statisticsNftView = statisticsNftView
        self.statisticsNftService = StatisticsNftsService.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = statisticsNftView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        fetchData()
    }
    
    // MARK: - Setup View
    private func setupView() {
        statisticsNftView.setCollectionViewDelegate(self)
        statisticsNftView.setCollectionViewDataSource(self)
    }
    
    // MARK: - Data Fetching
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getUserNfts { _ in
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
            statisticsNftView.updateCollection()
        }
    }
    
    private func fetchUserProfile(completion: @escaping (Bool) -> Void) {
        statisticsNftService.fetchProfile { [weak self] result in
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
    
    private func getUserNfts(completion: @escaping (Bool) -> Void){
        view.isUserInteractionEnabled = false
        ProgressHUD.show()
        statisticsNftService.fetchNfts(nftIds: nftIds ?? []) { [weak self] result in
            self?.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func fetchCart(completion: @escaping (Bool) -> Void) {
        statisticsNftService.fetchCart { [weak self] result in
            guard let self = self else { return completion(false) }
            switch result {
            case .success(let cart):
                self.cart = cart.nfts
                print("Cart: \(self.cart)")
                completion(true)
            case .failure(let error):
                print("⚠️ Ошибка загрузки корзины: \(error)")
                completion(false)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StatisticsNftCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NFTS \(self.nfts.count)")
        return self.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsNftCell.reuseIdentifier, for: indexPath)
        guard let statisticsNftCell = cell as? StatisticsNftCell else {
            assertionFailure("Cell is null for StatisticsNftCell")
            return UICollectionViewCell()
        }
        statisticsNftCell.delegate = self
        let nft = nfts[indexPath.row]
        statisticsNftCell.configureCell(with: nft, cart: cart ?? [""], likes: likes ?? [""])
        return statisticsNftCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsNftCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

//MARK: - StatisticsNftCellDelegate protocol implementation
extension StatisticsNftCollectionController: StatisticsNftCellDelegate {
    func likeButtonTapped(for nft: NftById) {
        guard let likes else { return }
        ProgressHUD.show()
        statisticsNftService.updateLike(with: nft.id, in: likes) { result in
            switch result {
            case .success(let result):
                self.likes = result.likes
            case .failure(let error):
                print("⚠️ Ошибка при обновлении лайков: \(error)")
            }
            ProgressHUD.dismiss()
        }
    }
    
    func bucketButtonTapped(for nft: NftById) {
        guard let cart else { return }
        ProgressHUD.show()
        statisticsNftService.updateOrder(with: nft.id, in: cart) { result in
            switch result {
            case .success(let result):
                self.cart = result.nfts
            case .failure(let error):
                print("⚠️ Ошибка при обновлении корзины: \(error)")
            }
            ProgressHUD.dismiss()
        }
    }
}
