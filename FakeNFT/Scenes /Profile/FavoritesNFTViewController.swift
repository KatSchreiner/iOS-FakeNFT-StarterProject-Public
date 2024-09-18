//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 11.09.2024.
//

import UIKit

final class FavoritesNFTViewController: UIViewController {
    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // TODO: - ЭПИК 3/3
    }
    // MARK: - IB Actions
    // MARK: - Public Methods
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Избранные NFT"
    }
    // MARK: - UIUICollectionViewDataSource
    // MARK: - UIUICollectionViewDelegate
}
