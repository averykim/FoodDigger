//
//  LoginView.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class LoginView: UIView {

    var onCloseTapped: (() -> Void)?
    var onRegisterTapped: (() -> Void)?
    var onLoginTapped: (() -> Void)?
    var onFindTapped: (() -> Void)?

    let emailInput = InputView(title: "Email", placeholder: "emailBox", keyboardType: .emailAddress)
    let passwordInput = InputView(title: "Password", placeholder: "passwordBox", keyboardType: .default, isSecure: true)
    let registerButton = UIButton()
    let findButton = UIButton()
    let loginButton = UIButton()

    let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor
        let closeButton = UIButton()
        closeButton.backgroundColor = DiggerColor.textFieldColor
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton, anchors: [.top(30), .leading(20), .width(40), .height(40)])
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)

        //Find password
        findButton.setTitle("Forgot password?", for: .normal)
        findButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        findButton.titleLabel?.font =  UIFont(name: "BMJUA", size: 14)
        findButton.contentHorizontalAlignment = .right
        findButton.addTarget(self, action: #selector(pressFindButton), for: .touchUpInside)

        //Login
        loginButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "BMJUA", size: 28)
        loginButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(pressLoginButton), for: .touchUpInside)

        let mainStackView =  UIStackView(arrangedSubviews: [emailInput, passwordInput, findButton, loginButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.distribution = .fill
        mainStackView.setCustomSpacing(8, after: passwordInput)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView, anchors: [.centerY(-20), .leading(30), .trailing(-30)])

        //Register
        let registerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "BMJUA", size: 20) ?? UIFont.systemFont(ofSize: 20),
            .foregroundColor: DiggerColor.mainTextColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: 2
        ]
        let registerString = NSAttributedString(string: "Register", attributes: registerAttributes)
        registerButton.setAttributedTitle(registerString, for: .normal)


        addSubview(registerButton, anchors: [.bottom(-60), .centerX(0)])
        registerButton.addTarget(self, action: #selector(pressRegisterButton), for: .touchUpInside)

        addSubview(activityIndicator, anchors: [.centerX(0), .centerY(0)])
        bringSubviewToFront(activityIndicator)
        activityIndicator.color = .darkGray
    }

    @objc
    private func pressCloseButton() {
        onCloseTapped?()
    }

    @objc
    private func pressRegisterButton() {
        onRegisterTapped?()
    }

    @objc
    private func pressFindButton() {
        onFindTapped?()
    }

    @objc
    private func pressLoginButton() {
        self.endEditing(true)
        onLoginTapped?()
    }

    func shakeTextField(textField: UITextField) -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
