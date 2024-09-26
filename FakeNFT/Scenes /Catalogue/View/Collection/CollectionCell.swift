import UIKit
import Kingfisher

// MARK: - CatalogueCell
final class CollectionCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "CollectionCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stars 0")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var likeButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "Like default"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(Self.likeButtonClicked), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var cartButton = {
        let cartButton = UIButton()
        cartButton.setImage(UIImage(named: "Cart add"), for: .normal)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addTarget(self, action: #selector(Self.cartButtonClicked), for: .touchUpInside)
        return cartButton
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Public methods
    func configure(with nft: NFT, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        
        if let imageURL = nft.images.first {
            let url = URL (string: imageURL)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url,
                                  placeholder: UIImage(),
                                  completionHandler: { result in
                switch result {
                case.success(let value):
                    self.imageView.image = value.image
                    completion(.success(value))
                case.failure(let error):
                    completion(.failure(error))
                }
            })
        }
        let imageNames = ["Stars 0", "Stars 1", "Stars 2", "Stars 3", "Stars 4", "Stars 5"]
        let imageName = imageNames[nft.rating]
        ratingView.image = UIImage(named: imageName)
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
    }
    
    // MARK: Actions
    @objc
    private func likeButtonClicked() {
        likeButton.isSelected.toggle()
        if likeButton.isSelected {
            print("❤️ Кнопка нажата: true")
            changeLikeButtonImageFor(state: true)
        } else {
            print("❤️ Кнопка нажата: false")
            changeLikeButtonImageFor(state: false)
        }
        //delegate?.likeButtonClicked(self)
    }
    
    @objc
    private func cartButtonClicked() {
        cartButton.isSelected.toggle()
        if cartButton.isSelected {
            print("🛒 Кнопка нажата: true")
            changeCartButtonImageFor(state: true)
        } else {
            print("🛒 Кнопка нажата: false")
            changeCartButtonImageFor(state: false)
        }
        //delegate?.cartButtonClicked(self)
    }
    
    // MARK: Private methods
    private func changeLikeButtonImageFor(state isLiked: Bool) {
        let imageName = isLiked ? "Like default" : "Like pressed"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func changeCartButtonImageFor(state isLiked: Bool) {
        let imageName = isLiked ? "Cart add" : "Cart delete"
        cartButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

// MARK: - Set View
extension CollectionCell {
    private func setView() {
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.widthAnchor.constraint(equalToConstant: 108)
        ])
        
        contentView.addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(cartButton)
        NSLayoutConstraint.activate([
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([cartButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)])
    }
}
