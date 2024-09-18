//
//  RatingView.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import UIKit

class RatingView: UIView {
    var stars: [UIImageView] = []
    let totalStars: Int = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStars() {
        for star in 0..<totalStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .secondary
            
            addSubview(starImageView)
            stars.append(starImageView)
            
            NSLayoutConstraint.activate([
                starImageView.leadingAnchor.constraint(equalTo: star == 0 ? self.leadingAnchor : stars[star - 1].trailingAnchor, constant: 4),
                starImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
    }
    
    func setRating(_ rating: Int) {
        for (index, star) in stars.enumerated() {
            if index < rating {
                star.image = UIImage(systemName: "star.fill")
            } else {
                star.image = UIImage(systemName: "star.fill")
                star.tintColor = .nGray
            }
        }
    }
}
