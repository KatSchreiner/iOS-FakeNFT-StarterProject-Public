import UIKit
import ProgressHUD

final class NewViewController: UIViewController {
    
    // MARK: Properties
    private let catalogueService: CatalogueService
    private let nfts: [String]
    private var nftsList: [NFT] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        fetchNFT(nfts: nfts)
    }
    
    // MARK: Data Fetching
    private func fetchNFT(nfts: [String], index: Int = 0) {
        ProgressHUD.show()
        
        guard index < nfts.count else {
            ProgressHUD.dismiss()
            return
        }
        let id = nfts[index]
        
        catalogueService.fetchNFT(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    print("✅ Успех: \(nft)")
                    self.nftsList.append(nft)
                    self.fetchNFT(nfts: nfts, index: index + 1)
                    // TODO: Обновить UI
                case .failure(let error):
                    print("⚠️ Ошибка: \(error)")
                    self.fetchNFT(nfts: nfts, index: index + 1)
                }
            }
            ProgressHUD.dismiss()
        }
    }
}
