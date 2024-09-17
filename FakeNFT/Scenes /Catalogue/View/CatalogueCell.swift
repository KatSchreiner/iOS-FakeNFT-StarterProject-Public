import UIKit
import Kingfisher

// MARK: - CatalogueCell
final class CatalogueCell: UITableViewCell {
    
    // MARK: Properties
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "YP Black")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = UIImage()
    }
    
    // MARK: Public methods
    func configure(name: String, imageURL: String, completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> Void) {
        
        if let url = URL(string: imageURL) {
            cellImageView.kf.indicatorType = .activity
            cellImageView.kf.setImage(with: url,
                                      placeholder: UIImage(),
                                      completionHandler: { result in
                switch result {
                case.success(let value):
                    let loadedImage = value.image
        
                    guard let resizedImage = loadedImage.resizedToFit(width: self.contentView.frame.width) else {
                        self.cellImageView.image = loadedImage
                        return
                    }
                    self.cellImageView.image = resizedImage
                    completion(.success(value))
                case.failure(let error):
                    completion(.failure(error))
                }
            })
        }
        nameLabel.text = name
    }
    
    // MARK: Private methods
    private func setView() {
        contentView.addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }
}

// MARK: - Extension UIImage
extension UIImage {
    func resizedToFit(width: CGFloat) -> UIImage? {
        let aspectRatio = size.height / size.width
        let newHeight = width * aspectRatio
        let newSize = CGSize(width: width, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
