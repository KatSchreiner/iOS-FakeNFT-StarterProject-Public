//
//  FavoriteCollectionViewCell.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 23.09.2024.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    private var nft: NFT?

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite_noActive"), for: .normal)
        button.setImage(UIImage(named: "favorite_active"), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingView = RatingView()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc private func favoriteButtonTapped() {
        print("Favorite button tapped")
        favoriteButton.isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [imageView, favoriteButton, nameLabel, ratingView, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0) 
        }
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 76),
            
            ratingView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(with nft: NFT) {
        setImage(nft: nft)
        nameLabel.text = nft.name
        ratingView.setRating(nft.rating)
        priceLabel.text = "\(nft.price) ETH"
    }
    
    private func setImage(nft: NFT) {
        if let imageUrlString = nft.images.first, let url = URL(string: imageUrlString) {
            imageView.kf.setImage(with: url)
        } else {
            print("Нет доступных изображений для NFT: \(nft.name)")
            self.imageView.image = nil
        }
    }
}
