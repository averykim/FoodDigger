//
//  InputView.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/29/26.
//

import UIKit

class InputView: UIView {

    let titleLabel = UILabel()
    let textField = UITextField()
    let eyeButton = UIButton(type: .custom)
    let errorLabel = UILabel()

    init(title: String, placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool = false) {
        super.init(frame: .zero)

        titleLabel.text = title
        titleLabel.font = UIFont(name: "BMJUA", size: 14)
        titleLabel.textColor = DiggerColor.mainTextColor

        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.backgroundColor = DiggerColor.textBoxColor
        textField.textColor = DiggerColor.mainTextColor
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString(placeholder, comment: ""),
                                                             attributes: [NSAttributedString.Key.foregroundColor: DiggerColor.placeholderColor])
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = DiggerColor.mainTextColor.cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
        textField.leftViewMode = .always

        if isSecure {
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeButton.tintColor = DiggerColor.placeholderColor
            eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)

            let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
            eyeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 50)
            rightViewContainer.addSubview(eyeButton)
            textField.rightView = rightViewContainer
            textField.rightViewMode = .always
        }

        errorLabel.textColor = .systemRed
        errorLabel.font = UIFont(name: "BMJUA", size: 12)
        errorLabel.isHidden = true

        //StackView
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView, anchors: [.top(0), .bottom(0), .leading(0), .trailing(0)])
    }

    @objc
    private func toggleVisibility() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        return textField.text
    }

    func showError(_ state: Bool, message: String?) {
//        if let message = message, !message.isEmpty {
//            errorLabel.text = message
//            errorLabel.isHidden = false
//        } else {
//            errorLabel.isHidden = true
//        }
        errorLabel.text =  message
        errorLabel.isHidden = state
    }
}
