import UIKit
import Kingfisher

// MARK: - CollectionViewProtocol
protocol CollectionViewProtocol: AnyObject {
    
}

// MARK: - CollectionView
final class CollectionView: UIView, CollectionViewProtocol {
    
    // MARK: Properties
    private var aspectRatioConstraint: NSLayoutConstraint?
    private var urlToOpen: String?
    private var router: CollectionRouterProtocol?
    
    // MARK: View
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
    
    // MARK: Initialization
    init(frame: CGRect,
         router: CollectionRouterProtocol?
    ) {
        self.router = router // Устанавливаем роутер при инициализации
        super.init(frame: frame)
        backgroundColor = UIColor(named: "YP White")
        testSetting()
        downloadImage()
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Private methods
    private func testSetting() {
        nameLabel.text = "Peach"
        authorTextLabel.text = "Автор коллекции:"
        authorLabel.text = "John Doe"
        descriptionLabel.text = "Персиковый — как облака над закатным солнце в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        
        setAttributedText("John Doe")
        setURL("https://practicum.yandex.ru/ios-developer/")
    }
    
    private func downloadImage() {
        if let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png") {
            coverImageView.kf.indicatorType = .activity
            coverImageView.kf.setImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success(let value):
                    let image = value.image
                    coverImageView.image = image
                    setHeightForCoverImage(image: image)
                    print("✅ Изображение загружено")
                case.failure(let error):
                    print("⚠️ Ошибка", error)
                }
            }
        }
    }
    
    private func setHeightForCoverImage(image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        self.aspectRatioConstraint = self.coverImageView.widthAnchor.constraint(equalTo: self.coverImageView.heightAnchor, multiplier: aspectRatio)
        self.aspectRatioConstraint?.isActive = true
    }
    
    private func setupView() {
        addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16)
        ])
        
        addSubview(authorTextLabel)
        NSLayoutConstraint.activate([
            authorTextLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authorTextLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 57),
        ])
        
        addSubview(authorLabel)
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: authorTextLabel.trailingAnchor, constant: 4),
            authorLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 56),
        ])
        
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5)
        ])
    }
    
    // MARK: CollectionViewProtocol Methods
    func setAttributedText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: attributedString.length))
        
        authorLabel.attributedText = attributedString
    }
    
    func setURL(_ url: String) {
        self.urlToOpen = url
    }
    
    // MARK: Actions
    
    @objc private func linkTapped() {
        guard let urlString = urlToOpen, let url = URL(string: urlString) else { return }
        
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
