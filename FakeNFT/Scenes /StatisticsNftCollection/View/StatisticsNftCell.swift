import UIKit
import Kingfisher

final class StatisticsNftCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let reuseIdentifier = "StatisticsNftCell"
    
    // MARK: - Private Properties
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
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
    
    // MARK: - Actions
    @objc private func likeDidTap() {
        print("likeDidTap")
    }
    
    @objc private func bucketDidTap() {
        print("bucketDidTap")
    }
}

