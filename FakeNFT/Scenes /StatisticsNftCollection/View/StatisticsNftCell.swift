import UIKit
import Kingfisher

final class StatisticsNftCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let reuseIdentifier = "StatisticsNftCell"
    
    // MARK: - Private Properties
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bucketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bucket"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(bucketDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView = RatingView()
    private let networkClient = DefaultNetworkClient()
    private var nft: NftById?
    private var isNftInOrder = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubiews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureCell(with nft: NftById?) {
        guard let nft = nft else { return }
        self.nft = nft
        nameLabel.text = nft.name.contains(" ") ? nft.name.components(separatedBy: " ").first : nft.name
        ratingView.setRating(nft.rating)
        print("Rating is \(nft.rating)")
        priceLabel.text = "\(nft.price) ETH"
        
        guard let validUrl = nft.getImageUrl() else {
            print("Image url is not correct")
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        imageBackground.kf.indicatorType = .activity
        imageBackground.kf.setImage(with: validUrl,
                                    options: [
                                        .processor(processor),
                                        .transition(.fade(1)),
                                        .scaleFactor(UIScreen.main.scale),
                                        .cacheOriginalImage
                                    ])
        let likedNFTs = UserDefaults.standard.array(forKey: "likedNFTs") as? [String] ?? []
        print(UserDefaults.standard.array(forKey: "likedNFTs") ?? "no liked nfts")
        if likedNFTs.contains(nft.id) {
            likeButton.tintColor = .red
        } else {
            likeButton.tintColor = .white
        }
        checkIfNftInOrder(nft: nft)
    }
    
    // MARK: - Private Methods
    private func addSubiews(){
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        [imageBackground, likeButton, bucketButton, nameLabel, priceLabel, ratingView].forEach({contentView.addSubview($0)})
    }
    
    private func makeConstraints(){
        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackground.widthAnchor.constraint(equalToConstant: 108),
            imageBackground.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: imageBackground.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageBackground.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            
            bucketButton.widthAnchor.constraint(equalToConstant: 40),
            bucketButton.heightAnchor.constraint(equalToConstant: 40),
            bucketButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            bucketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func checkIfNftInOrder(nft: NftById) {
        let fetchOrderRequest = StatisticsOrderRequest()
        networkClient.send(request: fetchOrderRequest, type: Order.self, completionQueue: .main) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                if order.nfts.contains(nft.id) {
                    self.isNftInOrder = true
                    self.bucketButton.setImage(UIImage(named: "bucketFull"), for: .normal)
                } else {
                    self.isNftInOrder = false
                    self.bucketButton.setImage(UIImage(named: "bucket"), for: .normal)
                }
            case .failure(let error):
                print("Failed to fetch order: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func likeDidTap() {
        guard let nftId = nft?.id else { return }
        var likedNFTs = UserDefaults.standard.array(forKey: "likedNFTs") as? [String] ?? []
        print(UserDefaults.standard.array(forKey: "likedNFTs") ?? "No nfts")
        if likedNFTs.contains(nftId) {
            likedNFTs.removeAll { $0 == nftId }
            likeButton.tintColor = .white
            print("Unliked NFT with id: \(nftId)")
        } else {
            likedNFTs.append(nftId)
            likeButton.tintColor = .red
            print("Liked NFT with id: \(nftId)")
        }
        UserDefaults.standard.setValue(likedNFTs, forKey: "likedNFTs")
        UserDefaults.standard.synchronize()
    }
    
    @objc private func bucketDidTap() {
        guard let nft = nft else { return }
        if isNftInOrder {
            let fetchOrderRequest = StatisticsOrderRequest()
            self.bucketButton.setImage(UIImage(named: "bucket"), for: .normal)
        } else {
            let fetchOrderRequest = StatisticsOrderRequest()
            networkClient.send(request: fetchOrderRequest, type: Order.self, completionQueue: .main) { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(var order):
                    print("Fetched order: \(order)")
                    order.addNft(nft.id)
                    let updateOrderRequest = StatisticsOrderUpdate(nftId: nft.id)
                    self.networkClient.send(request: updateOrderRequest, completionQueue: .main) { result in
                        switch result {
                        case .success(_):
                            print("Successfully updated the order with NFT.")
                            self.isNftInOrder = true
                            self.bucketButton.setImage(UIImage(named: "bucketFull"), for: .normal)
                        case .failure(let failure):
                            print("Failed to update the order: \(failure)")
                        }
                    }
                case .failure(let failure):
                    print("Failed to fetch order: \(failure)")
                }
            }
        }
    }
}
