//
//  FavoriteCollectionViewCell.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 23.09.2024.
//

import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func didTapRemoveFromFavorites(nftId: String)
}

final class FavoriteCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    weak var delegate: FavoriteCellDelegate?
    
    // MARK: - Private Properties
    private var nft: NFT?
    private var profile: Profile?
    
    private lazy var FavoriteImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: "favorite.active"), for: .selected)
        favoriteButton.setImage(UIImage(named: "favorite.no.active"), for: .normal)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return favoriteButton
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
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - IB Actions
    @objc private func didTapFavoriteButton() {
        guard let nftId = nft?.id else { return }
        delegate?.didTapRemoveFromFavorites(nftId: nftId)
        favoriteButton.isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with nft: NFT, profile: Profile) {
        self.nft = nft
        self.profile = profile
        
        setImage(nft: nft)
        nameLabel.text = nft.name
        ratingView.setRating(nft.rating)
        priceLabel.text = "\(nft.price) ETH"
        
        favoriteButton.isSelected = profile.likes.contains(nft.id)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [FavoriteImageView, favoriteButton, nameLabel, ratingView, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            FavoriteImageView.widthAnchor.constraint(equalToConstant: 80),
            FavoriteImageView.heightAnchor.constraint(equalToConstant: 80),
            
            favoriteButton.topAnchor.constraint(equalTo: FavoriteImageView.topAnchor, constant: 3),
            favoriteButton.trailingAnchor.constraint(equalTo: FavoriteImageView.trailingAnchor, constant: -4),
            
            nameLabel.leadingAnchor.constraint(equalTo: FavoriteImageView.trailingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 76),
            
            ratingView.leadingAnchor.constraint(equalTo: FavoriteImageView.trailingAnchor, constant: 12),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: FavoriteImageView.trailingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10)
        ])
    }
    
    private func setImage(nft: NFT) {
        if let imageUrlString = nft.images.first, let url = URL(string: imageUrlString) {
            FavoriteImageView.kf.setImage(with: url)
        } else {
            print("⚠️ [FavoriteCollectionViewCell:setImage]: Нет доступных изображений для NFT: \(nft.name)")
            self.FavoriteImageView.image = nil
        }
    }
}
