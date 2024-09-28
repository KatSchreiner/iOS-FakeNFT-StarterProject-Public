import UIKit
import Kingfisher

// MARK: - CollectionViewProtocol
protocol CollectionViewProtocol: AnyObject {
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate)
    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource)
    func register(cellType: UICollectionViewCell.Type, reuseIdentifier: String)
    func configureView(with collection: NFTCollections)
    func reloadData()
}

// MARK: - CollectionView
final class CollectionView: UIView, CollectionViewProtocol {
    
    // MARK: Properties
    private var aspectRatioConstraint: NSLayoutConstraint?
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var urlToOpen = "https://practicum.yandex.ru/ios-developer/"
    private var router: CollectionRouterProtocol?
    
    // MARK: View
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: Initialization
    init(frame: CGRect,
         router: CollectionRouterProtocol?
    ) {
        self.router = router
        super.init(frame: frame)
        backgroundColor = UIColor(named: "YP White")
        setupView()
        reloadData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Private methods
    
    private func downloadImage(url: String) {
        if let url = URL(string: url) {
            coverImageView.kf.indicatorType = .activity
            coverImageView.kf.setImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success(let value):
                    let image = value.image
                    coverImageView.image = image
                    setHeightForCoverImage(image: image)
                case.failure(let error):
                    print("⚠️ Ошибка загрузки изображения:", error)
                }
            }
        }
    }
    
    // MARK: - CollectionViewProtocol Methods
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func register(cellType: UICollectionViewCell.Type, reuseIdentifier: String) {
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureView(with collection: NFTCollections) {
        nameLabel.text = collection.name
        authorTextLabel.text = "Автор коллекции:"
        authorLabel.text = collection.author
        setAttributedText(collection.author)
        descriptionLabel.text = collection.description
        downloadImage(url: collection.cover)
    }
    
    func reloadData() {
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.collectionViewHeightConstraint?.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    // MARK: Mock Methods
    func setAttributedText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: attributedString.length))
        
        authorLabel.attributedText = attributedString
    }
    
    // MARK: Actions
    @objc private func linkTapped() {
        guard let url = URL(string: urlToOpen) else { return }
        router?.navigateToWebViewController(from: parentViewController() ?? UIViewController(), url: url)
    }
    
    private func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - Setup View
extension CollectionView {
    
    private func setHeightForCoverImage(image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        self.aspectRatioConstraint = self.coverImageView.widthAnchor.constraint(equalTo: self.coverImageView.heightAnchor, multiplier: aspectRatio)
        self.aspectRatioConstraint?.isActive = true
    }
    
    private func setupView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16)
        ])
        
        contentView.addSubview(authorTextLabel)
        NSLayoutConstraint.activate([
            authorTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorTextLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 57),
        ])
        
        contentView.addSubview(authorLabel)
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: authorTextLabel.trailingAnchor, constant: 4),
            authorLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 56),
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5)
        ])
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
    }
}
