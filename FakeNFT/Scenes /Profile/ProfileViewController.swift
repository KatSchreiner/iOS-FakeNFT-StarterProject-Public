//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 07.09.2024.
//

import UIKit
import WebKit
import Kingfisher
import ProgressHUD

final class ProfileViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Private Properties
    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(named: "square.and.pencil")
        let editButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapEditProfile))
        editButton.tintColor = .nBlack
        return editButton
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Photo"))
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .nBlack
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption2
        label.textColor = .nBlack
        label.attributedText = createAttributedDescriptionText("")
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .caption1
        label.textColor = .primary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapWebsiteLabel))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private var uiElements: [UIView] {
        return [profileImageView, nameLabel, descriptionLabel, websiteLabel, tableView]
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadProfile()
    }
    
    // MARK: - IB Actions
    @objc
    func didTapEditProfile() {
        print("[ProfileViewController:didTapEditProfile]: Редактирование профиля")
        let editProfileVC = EditProfileViewController()
        editProfileVC.delegate = self
        
        if let avatarURLString = ProfileService.shared.getAvatar() {
            editProfileVC.imagePath = avatarURLString
        }
        
        let currentProfile = Profile(
            name: nameLabel.text ?? "",
            avatar: editProfileVC.imagePath ?? "",
            description: descriptionLabel.text ?? "",
            website: websiteLabel.text ?? ""
        )
        
        editProfileVC.profile = currentProfile
        
        let navigationController = UINavigationController(rootViewController: editProfileVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapWebsiteLabel() {
        navigateToDeveloperInfo()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        [stackView, descriptionLabel, websiteLabel, tableView].forEach { [weak self] view in
            guard let self = self else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        navigationItem.rightBarButtonItem = editButton
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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
    
    private func loadProfile() {
        print("[ProfileViewController:loadProfile]: Загрузка данных профиля...")
        ProgressHUD.show()
        
        setUIElementsVisible(false)
        
        ProfileService.shared.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss() 
                switch result {
                case .success(let profile):
                    print("[ProfileViewController:loadProfile]: Данные профиля успешно отображены")
                    self?.updateDisplayProfile(with: profile)
                    if let avatarURL = ProfileService.shared.getAvatar() {
                        self?.profileImageView.kf.setImage(with: URL(string: avatarURL))
                    }
                    
                    self?.setUIElementsVisible(true)
                    
                case .failure(let error):
                    print("Ошибка при получении данных профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateDisplayProfile(with profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
    }
    
    private func setUIElementsVisible(_ isVisible: Bool) {
        uiElements.forEach { $0.isHidden = !isVisible }
    }
    
    private func createAttributedDescriptionText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: cellText(for: indexPath.row))
        
        return cell
    }
    
    private func cellText(for row: Int) -> String {
        switch row {
        case 0: return "Мои NFT (112)"
        case 1: return "Избранные NFT (11)"
        case 2: return "О разработчике"
        default: return ""
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        handleCellSelection(at: indexPath.row)
    }
    
    private func handleCellSelection(at index: Int) {
        switch index {
        case 0:
            navigationController?.pushViewController(MyNFTViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(FavoritesNFTViewController(), animated: true)
        case 2:
            navigateToDeveloperInfo()
        default: break
        }
    }
    
    private func navigateToDeveloperInfo() {
        guard let urlString = websiteLabel.text, let url = URL(string: urlString) else { return }
        let developerInfo = WebViewController()
        developerInfo.urlString = urlString
        navigationController?.pushViewController(developerInfo, animated: true)
    }
}

extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(with profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
        
        ProfileService.shared.setAvatar(profile.avatar)
        
        if let url = URL(string: profile.avatar) {
            profileImageView.kf.setImage(with: url)
        }
    }
}
