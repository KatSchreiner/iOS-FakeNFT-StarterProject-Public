//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(with profile: Profile)
}

final class EditProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Public Properties
    weak var delegate: EditProfileDelegate?
    
    var profile: Profile?
    var imagePath: String?
    
    // MARK: - Private Properties
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(overlayView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        
        return profileImageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = createLabel(with: "Сменить\nфото")
        label.font = .caption3
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var changePhotoLabel: UILabel = {
        let label = createLabel(with: "Загрузить изображение")
        label.font = .bodyRegular
        label.textColor = .nBlack
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAlertChangePhoto))
        label.addGestureRecognizer(tapGesture)
        label.alpha = 0
        
        return label
    }()
    
    private lazy var clearButton: UIButton = {
        let button = createButton(imageName: "cross", action: #selector(clearText))
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return button
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .custom)
        let image = UIImage(named: "xmark")
        closeButton.setImage(image, for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 16)
        closeButton.addTarget(self, action: #selector(didTapCloseEditProfile), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: closeButton)
        return barButtonItem
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let descriptionContainerView = UIView()
        descriptionContainerView.addSubview(descriptionTextView)
        descriptionContainerView.addSubview(clearDescriptionButton)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionContainerView
    }()
    
    private lazy var descriptionTextView: UITextView = createDescriptionTextView()
    
    private lazy var clearDescriptionButton: UIButton = {
        let button = createButton(imageName: "cross", action: #selector(clearDescriptionText))
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = createLabel(with: "Имя")
    private lazy var nameTextField: UITextField = createTextField()
    private lazy var descriptionLabel: UILabel = createLabel(with: "Описание")
    private lazy var websiteLabel: UILabel = createLabel(with: "Сайт")
    private lazy var websiteTextField: UITextField = createTextField()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, createSpacer(), descriptionLabel, descriptionContainerView, createSpacer(), websiteLabel, websiteTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadProfileData()
    }
    
    // MARK: - IB Actions
    @objc
    private func didTapCloseEditProfile() {
        let updatedProfile = Profile(
            name: nameTextField.text ?? "",
            avatar: imagePath ?? "",
            description: descriptionTextView.text ?? "",
            website: websiteTextField.text ?? ""
        )
        
        delegate?.didUpdateProfile(with: updatedProfile)
        print("[EditProfileViewController:didTapCloseEditProfile]: Данные профиля обновлены \(updatedProfile)")
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func clearText() {
        if nameTextField.isFirstResponder {
            nameTextField.text = ""
            print("[EditProfileViewController:clearText]: Текстовое поле 'Имя' очищено.")
        } else if websiteTextField.isFirstResponder {
            websiteTextField.text = ""
            print("[EditProfileViewController:clearText]: Текстовое поле 'Сайт' очищено")
        }
        clearButton.isHidden = true
    }
    
    @objc
    private func didTapProfileImageView() {
        changePhotoLabel.alpha = 1
    }
    
    @objc
    private func showAlertChangePhoto() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = self.imagePath
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.imagePath = text
                if let url = URL(string: text) {
                    self.profileImageView.kf.setImage(with: url)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func hideChangePhotoLabel() {
        changePhotoLabel.alpha = 0
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func clearDescriptionText() {
        print("[EditProfileViewController:clearDescriptionText]: Текстовое поле 'Описание' очищено.")
        descriptionTextView.text = ""
        clearDescriptionButton.isHidden = true
    }
    
    // MARK: - UITextFieldDelegate
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
    }
    
    @objc
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - UITextViewdDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        clearDescriptionButton.isHidden = textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearDescriptionButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        clearDescriptionButton.isHidden = true
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = closeButton
        
        hideLabel()
        hideKeyBoard()
        
        [stackView, profileImageView, changePhotoLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        updateTextViewHeight()
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            changePhotoLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            changePhotoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: changePhotoLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            label.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            clearDescriptionButton.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -10),
            clearDescriptionButton.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: -10),
            clearDescriptionButton.widthAnchor.constraint(equalToConstant: 30),
            clearDescriptionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func loadProfileData() {
        if let profile = profile {
            nameTextField.text = profile.name
            descriptionTextView.text = profile.description
            websiteTextField.text = profile.website
            let avatarURL = profile.avatar

            if let url = URL(string: avatarURL) {
                profileImageView.kf.setImage(with: url)
            }
        }
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .headline3
        return label
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .nGray
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.layer.masksToBounds = true
        textField.textAlignment = .left
        textField.delegate = self
        
        let textPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = textPadding
        textField.leftViewMode = .always
        
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        return textField
    }
    
    private func createDescriptionTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .nGray
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.textAlignment = .left
        textView.font = .bodyRegular
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        textView.delegate = self
        return textView
    }
    
    private func createButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func updateTextViewHeight() {
        let size = descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.bounds.width, height: .greatestFiniteMagnitude))
        let newHeight = max(size.height, 44)
        descriptionTextView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = newHeight
            }
        }
    }
    
    private func createSpacer() -> UIView {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return spacer
    }
    
    private func hideLabel() {
        let hidePhotoLabelGesture = UITapGestureRecognizer(target: self, action: #selector(hideChangePhotoLabel))
        hidePhotoLabelGesture.delegate = self
        view.addGestureRecognizer(hidePhotoLabelGesture)
    }
    
    private func hideKeyBoard() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGesture.delegate = self
        view.addGestureRecognizer(hideKeyboardGesture)
    }
}

extension EditProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
