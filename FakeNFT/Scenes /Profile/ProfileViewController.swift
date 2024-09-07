//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 07.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        return navigationBar
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(named: "square.and.pencil")
        let editButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapEditProfile))
        editButton.tintColor = .nBlack
        return editButton
    }()
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(image: UIImage(named: "Photo"))
        profileImageView.layer.cornerRadius = 35
        profileImageView.backgroundColor = .nBlack
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .headline3
        nameLabel.textColor = .nBlack
        nameLabel.text = "Joaquin Phoenix"
        return nameLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .caption2
        descriptionLabel.textColor = .nBlack
        
        let descriptionText = """
        Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.
        """
        let attributedString = NSMutableAttributedString(string: descriptionText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        descriptionLabel.attributedText = attributedString
        
        return descriptionLabel
    }()
    
    private lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.font = .caption1
        websiteLabel.textColor = .nBlue
        websiteLabel.text = "Joaquin Phoenix.com"
        return websiteLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IB Actions
    @objc
    func didTapEditProfile() {
        // TODO: Действие редактирования профиля
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground

        [navigationBar, stackView, descriptionLabel, websiteLabel, tableView].forEach { [weak self] view in
            guard let self = self else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        navigationBar.items = [UINavigationItem(title: "")]
        navigationBar.topItem?.rightBarButtonItem = editButton
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configure(with: "Мои NFT (112)")
        case 1:
            cell.configure(with: "Избранные NFT (11)")
        case 2:
            cell.configure(with: "О разработчике")
        default:
            break
        }
                
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}
