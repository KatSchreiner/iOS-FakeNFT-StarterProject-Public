import UIKit
import Kingfisher

// MARK: - CollectionCellDelegate
protocol CollectionCellDelegate: AnyObject {
    func cartButtonClicked(nft: String)
    func likeButtonClicked(nft: String)
}

// MARK: - CollectionCell
final class CollectionCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "CollectionCell"
    private var isLiked: Bool = false
    private var inCart: Bool = false
    private var nft: String?
    private var cart: [String]?
    private var likes: [String]?
    
    weak var delegate: CollectionCellDelegate?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.backgroundColor = .systemBackground
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    func configure(with nft: NFT, cart: [String], likes: [String]) -> Void {
        
        self.nft = nft.id
        self.cart = cart
        self.likes = likes
        
        guard let imageURL = nft.images.first else { return }
        downloadImage(from: imageURL)
        
        setRating(rating: nft.rating)
        
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        
        guard let cart = self.cart, let nft = self.nft, let likes = self.likes else { return }
        inCart = cart.contains(nft)
        cartButton(state: inCart)
        isLiked = likes.contains(nft)
        likeButton(state: isLiked)
    }
    
    // MARK: Actions
    @objc
    private func cartButtonClicked() {
        inCart.toggle()
        cartButton(state: inCart)
        guard let nft = nft else { return }
        delegate?.cartButtonClicked(nft: nft)
    }
    
    @objc
    private func likeButtonClicked() {
        isLiked.toggle()
        likeButton(state: isLiked)
        guard let nft = nft else { return }
        delegate?.likeButtonClicked(nft: nft)
    }
    
    // MARK: Private methods
    private func likeButton(state: Bool) {
        likeButton.isSelected = state
        likeButton.setImage(UIImage(named: isLiked ? "Like pressed" : "Like default"), for: .normal)
    }
    
    private func cartButton(state: Bool) {
        cartButton.isSelected = state
        cartButton.setImage(UIImage(named: inCart ? "Cart delete" : "Cart add"), for: .normal)
    }
    
    private func downloadImage(from imageURL: String) {
        
        let url = URL (string: imageURL)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(),
                              completionHandler: { result in
            switch result {
            case.success(let value):
                self.imageView.image = value.image
            case.failure(let error):
                print("⚠️ Ошибка загрузки изображения ячейки", error)
            }
        })
    }
    
    private func setRating(rating: Int) {
        for number in 0..<5 {
            let ratingImage = UIImageView()
            ratingStack.addArrangedSubview(ratingImage)
            switch number < rating {
            case true: ratingImage.image = UIImage(named: "Star active")
            case false: ratingImage.image = UIImage(named: "Star no active")
            }
        }
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
        
        contentView.addSubview(ratingStack)
        NSLayoutConstraint.activate([
            ratingStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
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
            stackView.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([cartButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)])
    }
}
