//
//  MyNFTsViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 11.09.2024.
//

import UIKit

final class MyNFTViewController: UIViewController {
    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // TODO: - ЭПИК 2/3
    }
    // MARK: - IB Actions
    // MARK: - Public Methods
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Мои NFT"
    }
    // MARK: - UITabvleViewDataSource
    // MARK: - UITabvleViewDelegate
}
