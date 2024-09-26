import UIKit
import ProgressHUD

// MARK: CollectionViewController
final class CollectionViewController: UIViewController {
    
    // MARK: Properties
    private let collectionView: CollectionViewProtocol
    private let collectionService: CatalogueService
    
    private let collection: NFTCollections
    private var nftsList: [NFT] = []
    private let dispatchGroup = DispatchGroup()
    private let nftsListQueue = DispatchQueue(label: "nftsListQueue", attributes: .concurrent)
    
    // MARK: Initialization
    init(with collection: NFTCollections,
         service: CatalogueService,
         view: CollectionViewProtocol
    ) {
        self.collectionView = view
        self.collection = collection
        self.collectionService = service
        super.init(nibName: nil, bundle: nil)
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
        print("ℹ️ Загружены данные: collection:", collection)
        print("ℹ️ Загружены данные: nfts:", collection.nfts)
        fetchAllNFTs()
    }
    
    // MARK: Setup View
    private func setupView() {
        collectionView.setCollectionViewDataSource(self)
        collectionView.setCollectionViewDelegate(self)
        collectionView.register(cellType: CollectionCell.self, reuseIdentifier: CollectionCell.identifier)
    }
    
    // MARK: Data Fetching
    private func fetchAllNFTs() {
        ProgressHUD.show()
        let nftsForLoad = collection.nfts
        
        for id in nftsForLoad {
            dispatchGroup.enter()
            collectionService.fetchNFT(id: id) { [weak self] result in
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
            print("✅ Все NFT загружены: \(self.nftsList.count)")
            self.updateUI()
        }
    }
    
    // MARK: View Updates
    private func updateUI() {
        collectionView.configureView(with: collection)
        self.collectionView.reloadData()
        print("✅ UI обновлен")
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ℹ️ Выбран элемент \(indexPath)")
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    
    // Количество строк
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Количество ячеек в строке
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftsList.count
    }
    
    // Ячейка
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
            print("⚠️ Ячейка коллекции не загружена")
            return UICollectionViewCell()
        }
        
        let nft = nftsList[indexPath.row]
        print("✅ Загружаем ячейку с NFT:", nft)
        cell.configure(with: nft) { result in
            switch result {
            case .success:
                print("✅ Элемент коллекции", indexPath, "обновлен!")
            case .failure:
                print("⚠️ Не удалось загрузить изображение")
                return
            }
        }
        return cell
    }
}

// MARK: - Extension UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Размер каждой ячейки в коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.bounds.width            // полная ширина коллекции
        let cellSpacing = CGFloat(9)                                 // отступ между ячейками
        let cellCount = CGFloat(3)                                   // количество ячеек в строке
        let cellHeight = CGFloat(192)                                // Высота каждой ячейки
        let cellWidth = CGFloat(108) /*(collectionWidth - cellSpacing*2) / cellCount*/
        return CGSize(width: cellWidth, height: cellHeight)  // Высоту не менять
    }
    
    // 2. Добавление отступов коллекции от краев экрана
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    // 3. Минимальное расстояние между ячейками (внутри коллекции) - вертикальные отступы
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
    
    // 4. Минимальное расстояние между ячейками (внутри коллекции) - горизонтальные отступы
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 9
    }
}
