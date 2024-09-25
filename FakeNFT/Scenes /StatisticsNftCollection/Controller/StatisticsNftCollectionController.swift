import UIKit
import ProgressHUD

final class StatisticsNftCollectionController: UIViewController {
    // MARK: - Private Properties
    private let statisticsNftView: StatisticsNftViewProtocol
    private let statisticsNftService: StatisticsNftsService
    private var nftIds: [String]?
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
        getUserNfts()
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        statisticsNftView.setCollectionViewDelegate(self)
        statisticsNftView.setCollectionViewDataSource(self)
    }
    
    // MARK: - Data Fetching
    private func getUserNfts(){
        view.isUserInteractionEnabled = false
        ProgressHUD.show()
        statisticsNftService.fetchNfts(nftIds: nftIds ?? []) { [weak self] result in
            self?.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
            case .failure(let error):
                print(error.localizedDescription)
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
        let nft = nfts[indexPath.row]
        statisticsNftCell.configureCell(with: nft)
        return statisticsNftCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsNftCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 16 - 16 - 16) / 3, height: 192)
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
