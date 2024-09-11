//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController, UITextViewDelegate {
    // MARK: - Public Properties
    var profile: Profile?
    var imagePath: String?
    
    // MARK: - Private Properties
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let label = createLabel(with: "Сменить\nфото")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption3
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        profileImageView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        
        return profileImageView
    }()
    
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton()
        let image = UIImage(named: "cross")
        clearButton.setImage(image, for: .normal)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return clearButton
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
    
    private lazy var nameLabel: UILabel = createLabel(with: "Имя")
    private lazy var nameTextField: UITextField = createTextField()
    private lazy var descriptionLabel: UILabel = createLabel(with: "Описание")
    private lazy var descriptionTextField: UITextView = createTextView()
    private lazy var websiteLabel: UILabel = createLabel(with: "Сайт")
    private lazy var websiteTextField: UITextField = createTextField()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, createSpacer(), descriptionLabel, descriptionTextField, createSpacer(), websiteLabel, websiteTextField])
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapProfileImageView() {
        showAlertChangePhoto()
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    @objc
    private func clearText() {
        if nameTextField.isFirstResponder {
            nameTextField.text = ""
            clearButton.isHidden = true
        } else if descriptionTextField.isFirstResponder {
            descriptionTextField.text = ""
            clearButton.isHidden = true
        } else if websiteTextField.isFirstResponder {
            websiteTextField.text = ""
            clearButton.isHidden = true
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = closeButton
        
        [stackView, profileImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        updateTextViewHeight()
    }
    
    private func loadProfileData() {
        if let profile = profile {
            nameTextField.text = profile.name
            descriptionTextField.text = profile.description
            websiteTextField.text = profile.website
            
            if let imagePath = imagePath, let url = URL(string: imagePath) {
                profileImageView.kf.setImage(with: url)
            }
        }
    }
    
    private func showAlertChangePhoto() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = self.imagePath
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.imagePath = text
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
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
        
        let textPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = textPadding
        textField.leftViewMode = .always
        
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }
    
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .nGray
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.textAlignment = .left
        textView.font = .bodyRegular
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        textView.delegate = self
        return textView
    }
    
    private func createSpacer() -> UIView {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return spacer
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
    }
    
    private func updateTextViewHeight() {
        let size = descriptionTextField.sizeThatFits(CGSize(width: descriptionTextField.bounds.width, height: .greatestFiniteMagnitude))
        descriptionTextField.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = size.height
            }
        }
    }
}
