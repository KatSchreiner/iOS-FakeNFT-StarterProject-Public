//
//  CustomTableViewCell.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 07.09.2024.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .bodyBold
        titleLabel.textColor = .nBlack
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with text: String) {
        titleLabel.text = text
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView?.tintColor = .nBlack
    }
}
