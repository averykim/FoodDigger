//
//  RegisterView.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class RegisterView: UIView {

    var onRegisterTapped: (() -> Void)?
    var onBackTapped: (() -> Void)?

    let emailInput = InputView(title: "Email", placeholder: "emailBox", keyboardType: .emailAddress)
    let usernameInput = InputView(title: "Name", placeholder: "usernameBox", keyboardType: .default)
    let pwInput = InputView(title: "Password", placeholder: "passwordBox", keyboardType: .default, isSecure: true)
    let pwConfirmInput = InputView(title: "Confirm Password", placeholder: "passwordConfirmBox", keyboardType: .default, isSecure: true)

    let registerButton = UIButton()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(backButton, anchors: [.top(30), .leading(20), .width(40), .height(40)])
        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)

        registerButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "BMJUA", size: 28)
        registerButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        registerButton.clipsToBounds = true
        registerButton.addTarget(self, action: #selector(pressRegisterButton), for: .touchUpInside)
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        emailInput.textField.returnKeyType = .next
        usernameInput.textField.returnKeyType = .next
        pwInput.textField.returnKeyType = .next
        pwConfirmInput.textField.returnKeyType = .done

        let mainStackView = UIStackView(arrangedSubviews: [emailInput, usernameInput, pwInput, pwConfirmInput, registerButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.distribution = .fill
        mainStackView.setCustomSpacing(32, after: pwConfirmInput)

        addSubview(mainStackView, anchors: [.centerY(-20), .leading(30), .trailing(-30)])

        addSubview(activityIndicator, anchors: [.centerX(0), .centerY(0)])
        bringSubviewToFront(activityIndicator)
        activityIndicator.color = .darkGray
    }

    @objc
    private func pressRegisterButton() {
        self.endEditing(true)
        onRegisterTapped?()
    }

    @objc
    private func dismissKeyboard() {
        self.endEditing(true)
    }

    @objc
    private func pressBackButton() {
        onBackTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
