//
//  FindPWView.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class FindPasswordView: UIView {

    var onSendTapped: (() -> Void)?
    var onBackTapped: (() -> Void)?

    let emailInput = InputView(title: "Email", placeholder: "emailBox", keyboardType: .emailAddress, isSecure: false)
    let sendButton = UIButton()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor
        let viewTitle = UILabel()
        viewTitle.text = "Find Password"
        viewTitle.font = UIFont(name: "BMJUA", size: 28)
        viewTitle.textColor = DiggerColor.mainTextColor
        viewTitle.textAlignment = .center

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(backButton, anchors: [.top(30), .leading(20), .width(40), .height(40)])
        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)

        let descLabel = UILabel()
        descLabel.text = ""
        descLabel.font = UIFont(name: "BMJUA", size: 28)
        descLabel.textColor = DiggerColor.placeholderColor
        descLabel.numberOfLines = 2
        descLabel.textAlignment = .center

        sendButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        sendButton.setTitle("SEND LINK", for: .normal)
        sendButton.titleLabel?.font = UIFont(name: "BMJUA", size: 20)
        sendButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        sendButton.clipsToBounds = true
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(pressSendButton), for: .touchUpInside)

        let mainStackView = UIStackView(arrangedSubviews: [viewTitle, descLabel, emailInput, sendButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.setCustomSpacing(10, after: viewTitle)
        mainStackView.setCustomSpacing(40, after: descLabel)
        addSubview(mainStackView, anchors: [.centerY(-40), .leading(30), .trailing(-30)])

        addSubview(activityIndicator, anchors: [.centerX(0), .centerY(0)])
        bringSubviewToFront(activityIndicator)
        activityIndicator.color = .darkGray
    }

    @objc
    private func pressSendButton() {
        onSendTapped?()
    }

    @objc
    private func pressBackButton() {
        onBackTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
