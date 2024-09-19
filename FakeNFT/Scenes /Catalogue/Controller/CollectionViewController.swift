import UIKit
import ProgressHUD

// MARK: CollectionViewController
final class CollectionViewController: UIViewController {
    
    // MARK: Properties
    private let catalogueService: CatalogueService
    private let nfts: [String]
    private var nftsList: [NFT] = []
    private let dispatchGroup = DispatchGroup()
    private let nftsListQueue = DispatchQueue(label: "nftsListQueue", attributes: .concurrent)
    
    // MARK: Initialization
    init(nfts: [String], catalogueService: CatalogueService) {
        self.catalogueService = catalogueService
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        fetchAllNFTs()
    }
    
    // MARK: Data Fetching
    private func fetchAllNFTs() {
        ProgressHUD.show()
        
        for id in nfts {
            dispatchGroup.enter()
            catalogueService.fetchNFT(id: id) { [weak self] result in
                defer {
                    self?.dispatchGroup.leave()
                }
                
                guard let self = self else { return }
                
                switch result {
                case .success(let nft):
                    print("✅ Успех: \(nft)")
                    self.nftsListQueue.async(flags: .barrier) {
                        self.nftsList.append(nft)
                    }
                case .failure(let error):
                    print("⚠️ Ошибка при загрузке NFT с id \(id): \(error)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            ProgressHUD.dismiss()
            print("✅ Все NFT загружены: \(nftsList)")
            // TODO: Обновить UI
            self.updateUI()
        }
    }
    
    // MARK: View Updates
    private func updateUI() {
            print("✅ UI обновлен")
        }
}
