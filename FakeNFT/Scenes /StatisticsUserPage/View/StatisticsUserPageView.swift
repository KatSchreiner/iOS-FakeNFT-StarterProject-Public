import UIKit

final class StatisticsUserPageView: UIView{
    
    // MARK: - Delegate
    weak var delegate: StatisticsUserPageViewDelegate?
    
    // MARK: - View
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        let image = UIImage(named: "stub_image") ?? UIImage()
        photoImageView.image = image
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 35
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        return photoImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.text = "Joaquin Phoenix"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.text = """
                Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var siteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openNFTCollection), for: .touchUpInside)
        
        let label = UILabel()
        label.text = "Коллекция NFT (112)"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let iconImageView = UIImageView(image: UIImage(named: "right_arrow"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [label, iconImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        [photoImageView, nameLabel, descriptionLabel, siteButton, collectionButton].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 41),

            descriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            siteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            siteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            siteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),

            collectionButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 56),
            collectionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    // MARK: - Actions
    @objc private func openWebView() {
        print("Open website")
        delegate?.didTapOpenWebView()
    }
        
    @objc private func openNFTCollection() {
        print("Open NFT collection")
        delegate?.didTapOpenNFTCollection()
    }
}
