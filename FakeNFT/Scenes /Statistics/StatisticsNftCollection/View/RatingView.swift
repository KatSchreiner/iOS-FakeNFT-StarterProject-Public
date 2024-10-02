import UIKit

final class RatingView: UIView {
    // MARK: - private properties
    private var stars: [UIImageView] = []
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func setRating(_ rating: Int) {
        for (index, star) in stars.enumerated() {
            if index < rating {
                star.tintColor = .yellow
            } else {
                star.image = UIImage(named: "star")
                star.tintColor = .gray
            }
        }
    }
    
    // MARK: - Private methods
    private func setupStars() {
        for star in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)

            addSubview(starImageView)
            stars.append(starImageView)
            
            NSLayoutConstraint.activate([
                starImageView.leadingAnchor.constraint(equalTo: star == 0 ? self.leadingAnchor : stars[star - 1].trailingAnchor, constant: 2),
                starImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
    }
}

