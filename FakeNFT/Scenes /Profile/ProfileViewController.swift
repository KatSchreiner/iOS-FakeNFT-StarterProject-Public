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
    private let servicesAssembly: ServicesAssembly
    private let webView = WKWebView()
    
    private var currentProfile: Profile?
    private var userNfts: [NFT] = []
    private var nftCount: Int = 0
    private var favoriteNftCount: Int = 0
    
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
        label.textColor = .systemBlue
        
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
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
        self.hidesBottomBarWhenPushed = false
    }
    
    // MARK: - IB Actions
    @objc
    func didTapEditProfile() {
        print("[ProfileViewController:didTapEditProfile]: Редактирование профиля")
        let editProfileVC = EditProfileViewController(servicesAssembly: servicesAssembly)
        editProfileVC.delegate = self
        
        if let profile = currentProfile {
            let currentProfileData = Profile(
                name: nameLabel.text ?? "",
                avatar: editProfileVC.newAvatarUrl ?? profile.avatar,
                description: descriptionLabel.text ?? "",
                website: websiteLabel.text ?? "",
                nfts: profile.nfts,
                likes: profile.likes,
                id: profile.id
            )
            editProfileVC.profile = currentProfileData
        } else {
            print("❌ [ProfileViewController:didTapEditProfile]: Текущий профиль отсутствует")
        }
        
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
        
        [profileImageView, nameLabel, descriptionLabel, websiteLabel, tableView].forEach { [weak self] view in
            guard let self = self else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        navigationItem.rightBarButtonItem = editButton
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 45),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Load Profile
    private func loadProfile() {
        print("[ProfileViewController:loadProfile]: Загрузка данных профиля...")
        ProgressHUD.show()
        
        setUIElementsVisible(false)
        
        servicesAssembly.profileServiceInstance.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                
                switch result {
                case .success(let profile):
                    print("✅ [ProfileViewController:loadProfile]: Данные профиля успешно отображены")
                    self?.currentProfile = profile
                    self?.loadNfts(for: profile)
                    self?.updateDisplayProfile(with: profile)
                    self?.setUIElementsVisible(true)
                    
                case .failure(let error):
                    print("❌ [ProfileViewController:loadProfile]: Ошибка при получении данных профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateDisplayProfile(with profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
        updateAvatar(url: profile.avatar)
        
        nftCount = profile.nfts.count
        favoriteNftCount = profile.likes.count
        
        tableView.reloadData()
    }
    
    private func updateAvatar(url: String) {
        guard let avatarUrl = URL(string: url) else { return }
        profileImageView.kf.setImage(with: avatarUrl)
    }
    
    // MARK: - Load NFT
    private func loadNfts(for profile: Profile) {
        ProgressHUD.show()
        servicesAssembly.nftListInstanse.fetchNfts { result in
            ProgressHUD.dismiss()
            
            switch result {
            case .success(let nfts):
                self.userNfts = nfts.filter { profile.nfts.contains($0.id) }
                DispatchQueue.main.async {
                    print("✅ [ProfileViewController:loadNfts]: Найдено NFT для пользователя: \(self.userNfts.count)")
                    self.nftCount = self.userNfts.count
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("❌ [ProfileViewController:loadNfts]: Ошибка получения NFT: \(error)")
            }
        }
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
        case 0: return "\(String("My.nft").localized()) (\(nftCount))"
        case 1: return "\(String("Love.nft").localized()) (\(favoriteNftCount))"
        case 2: return "About".localized()
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
            if let currentProfile = currentProfile {
                let myNftVC = MyNftViewController(servicesAssembly: servicesAssembly)
                myNftVC.delegate = self
                
                myNftVC.profile = currentProfile
                myNftVC.nfts = userNfts
                
                myNftVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(myNftVC, animated: true)
            }
        case 1:
            let favoritesVC = FavoriteNftViewController(servicesAssembly: servicesAssembly)
            favoritesVC.profile = currentProfile
            
            favoritesVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favoritesVC, animated: true)
        case 2:
            navigateToDeveloperInfo()
        default: break
        }
    }
    
    private func navigateToDeveloperInfo() {
        guard let urlString = websiteLabel.text, let url = URL(string: urlString) else { return }
        let developerInfo = WebViewControllerProfile(webView: webView)
        developerInfo.urlString = urlString
        
        developerInfo.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(developerInfo, animated: true)
    }
}

// MARK: - EditProfileDelegate
extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(with profile: Profile) {
        self.currentProfile = profile
        
        setAvatar(with: profile)
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
    }
    
    func setAvatar(with profile: Profile) {
        if let url = URL(string: profile.avatar) {
            self.profileImageView.kf.setImage(with: url)
        } else {
            self.profileImageView.image = UIImage(named: "placeholder_avatar")
        }
    }
}

// MARK: - MyNftViewControllerDelegate
extension ProfileViewController: MyNftViewControllerDelegate {
    func didUpdateLikes(_ likes: [String]) {
        func didUpdateLikes(_ likes: [String]) {
            currentProfile?.likes = likes
            favoriteNftCount = likes.filter { $0 == currentProfile?.id }.count
            tableView.reloadData()
        }
    }
}
