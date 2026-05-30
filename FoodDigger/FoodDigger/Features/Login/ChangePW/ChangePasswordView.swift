//
//  ProfileView.swift
//  FoodDigger
//
//  Created by JihyeKim on 5/7/26.
//

import UIKit

class ChangePasswordView: UIView {

    var onSaveTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?

    let containerView =  UIView()
    let oldPasswordInput = InputView(title: "Old Password", placeholder: "passwordBox", keyboardType: .default, isSecure: true)
    let newPaswwordInput = InputView(title: "New Password", placeholder: "passwordBox", keyboardType: .default, isSecure: true)
    let newPasswordConfirmInput = InputView(title: "Confirm Password",
                                            placeholder: "passwordBox", keyboardType: .default, isSecure: true)
    let saveButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .gray.withAlphaComponent(0.2)

        containerView.backgroundColor = DiggerColor.mainBackgroundColor
        containerView.layer.cornerRadius = 30
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity =  0.4
        addSubview(containerView, anchors: [.width(400), .height(500), .centerX(0), .centerY(20)])

        let title = UILabel()
        title.text = "Change password"
        title.font = UIFont(name: "BMJUA", size: 20)
        title.textAlignment = .center
        title.textColor = DiggerColor.mainTextColor
        containerView.addSubview(title, anchors: [.top(30), .centerX(0)])

        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "BMJUA", size: 20) ?? UIFont.systemFont(ofSize: 20),
            .foregroundColor: DiggerColor.mainTextColor,
            .baselineOffset: 2
        ]

        let closeButton = UIButton()
        closeButton.layer.cornerRadius = 20
        closeButton.backgroundColor = DiggerColor.headColor
        closeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let closeString = NSAttributedString(string: "Cancle", attributes: buttonAttributes)
        closeButton.setAttributedTitle(closeString, for: .normal)
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)

        saveButton.layer.cornerRadius = 20
        saveButton.backgroundColor = DiggerColor.headColor
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        let saveString = NSAttributedString(string: "Save", attributes: buttonAttributes)
        saveButton.setAttributedTitle(saveString, for: .normal)
        saveButton.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)

        oldPasswordInput.textField.returnKeyType = .next
        newPaswwordInput.textField.returnKeyType = .next
        newPasswordConfirmInput.textField.returnKeyType = .done

        let buttonStackView = UIStackView(arrangedSubviews: [closeButton, saveButton])
        buttonStackView.axis  = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20

        let stackView = UIStackView(arrangedSubviews: [oldPasswordInput, newPaswwordInput, newPasswordConfirmInput, buttonStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(50, after: newPasswordConfirmInput)
        containerView.addSubview(stackView, anchors: [.centerX(0), .centerY(0)])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc
    func pressCloseButton() {
        onCloseTapped?()
    }

    @objc
    func pressSaveButton() {
        onSaveTapped?()
    }

    @objc
    func dismissKeyboard() {
        endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
