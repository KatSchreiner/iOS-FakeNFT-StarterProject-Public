import UIKit

// MARK: - StatisticsNftViewProtocol
protocol StatisticsNftViewProtocol: AnyObject {
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate)
    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource)
    func updateCollection()
}

final class StatisticsNftView: UIView, StatisticsNftViewProtocol {
    // MARK: - View
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StatisticsNftCell.self, forCellWithReuseIdentifier: StatisticsNftCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    // MARK: - StatisticsNftViewProtocol Methods
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func updateCollection() {
        collectionView.reloadData()
    }
}
