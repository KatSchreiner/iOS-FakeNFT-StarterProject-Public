//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import UIKit
import Kingfisher

protocol MyNftCellLikeDelegate: AnyObject {
    func didUpdateFavoriteStatus(isLiked: Bool, for nftId: String, profileId: String)
}

final class MyNftTableViewCell: UITableViewCell {
    // MARK: - Public Properties
    weak var delegate: MyNftCellLikeDelegate?

    // MARK: - Private Properties
    private var nft: NFT?
    private var profile: Profile?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .nBlack
        return label
    }()
    
    private lazy var ratingView = RatingView()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .nBlack
        return label
    }()
    
    private lazy var priceTextLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nBlack
        label.text = "Price".localized()
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: "favorite.active"), for: .selected)
        favoriteButton.setImage(UIImage(named: "favorite.no.active"), for: .normal)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return favoriteButton
    }()
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IB Actions
    @objc
    private func didTapFavoriteButton() {
        guard let nftId = nft?.id, let profileId = profile?.id else { return }
        
        if let profileLikes = profile?.likes {
            let isLiked = !profileLikes.contains(nftId)
            delegate?.didUpdateFavoriteStatus(isLiked: isLiked, for: nftId, profileId: profileId)
        }
    }
    
    // MARK: - Public Methods
    func configure(with nft: NFT, profile: Profile) {
        self.nft = nft
        self.profile = profile
        
        setImage(with: nft)
        nameLabel.text = nft.name
        ratingView.setRating(nft.rating)
        authorLabel.text = "\(String("From:").localized()) \(nft.author)"
        priceLabel.text = "\(nft.price) ETH"
        
        favoriteButton.isSelected = profile.likes.contains(nft.id)
    }
    
    // MARK: - Private Methods
    private func setupSubviews() {
        [nftImageView, nameLabel, ratingView, authorLabel, priceLabel, priceTextLabel, favoriteButton].forEach { contentView in
            contentView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(contentView)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -10),
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 10),
            
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            
            ratingView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 11),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 24),
            
            authorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            authorLabel.widthAnchor.constraint(equalToConstant: 130),
            
            priceTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceTextLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 150),
            
            priceTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 150),
            priceLabel.topAnchor.constraint(equalTo: priceTextLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func setImage(with nft: NFT) {
        if let imageUrlString = nft.images.first, let url = URL(string: imageUrlString) {
            nftImageView.kf.setImage(with: url)
        } else {
            print("⚠️ [MyNftTableViewCell:setImage]: Нет доступных изображений для NFT: \(nft.name)")
            self.nftImageView.image = nil
        }
    }
}
