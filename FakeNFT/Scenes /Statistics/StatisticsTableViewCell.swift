import UIKit
import Kingfisher

final class StatisticsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsTableViewCell"
    private lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.text = "1"
        indexLabel.textColor = .black
        indexLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return indexLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Alex"
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return nameLabel
    }()
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageSize = CGSize(width: 28, height: 28)
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            photoImageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
        let image = UIImage(named: "stub_image") ?? UIImage()
        photoImageView.image = image
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = imageSize.width / 2
        return photoImageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "122"
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return ratingLabel
    }()
    
    private lazy var greyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        makeConstraints()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        configureCell()
    }
    
    func configureCell(index: String? = nil, name: String? = nil, rating: String? = nil, url: String? = nil) {
        indexLabel.text = index
        nameLabel.text = name
        ratingLabel.text = rating
        guard let url = url, let imageUrl = URL(string: url) else {
            print("Image url is not correct")
            return
        }
        let imageSize = CGSize(width: 28, height: 28)
        let processor = RoundCornerImageProcessor(cornerRadius: imageSize.width / 2)
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: imageUrl,
                                   placeholder: UIImage(named: "placeholder"),
                                   options: [
                                    .processor(processor),
                                    .transition(.fade(1))
                                   ]) { result in
                                       switch result {
                                       case .success(let value):
                                           print(value.image)
                                           print(value.cacheType)
                                           print(value.source)
                                       case .failure(let error):
                                           print("[showFullImage] \(error.localizedDescription)")
                                       }
                                   }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews(){
        [indexLabel, nameLabel, photoImageView, ratingLabel].forEach({contentView.addSubview($0)})
        contentView.insertSubview(greyView, at: 0)
    }
    
    private func makeConstraints(){
        NSLayoutConstraint.activate([
            greyView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            greyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 51),
            greyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            greyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            indexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            indexLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            indexLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: greyView.leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: greyView.leadingAnchor, constant: 52),
            
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: greyView.trailingAnchor, constant: -16)
        ])
    }
}
