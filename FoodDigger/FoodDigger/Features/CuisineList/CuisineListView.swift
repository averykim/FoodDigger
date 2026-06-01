//
//  CuisineView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import UIKit

class CuisineListView: UIView {
    
    var onNextButtonTapped: (() -> Void)?
    var onAuthButtonTapped: (() -> Void)?
    var onHistoryButtonTapped: (() -> Void)?
    var onChangePasswordTapped: (() -> Void)?
    var onLogoutTapped: (() -> Void)?

    let collectionView = CuisineCollectionView(frame: .zero,
                                                           collectionViewLayout: UICollectionViewFlowLayout())
    let authButton = UIButton(type: .system)
    let historyButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor

        addSubview(authButton, anchors: [.top(60), .trailing(-30)])
        authButton.addTarget(self, action: #selector(pressAuthButton), for: .touchUpInside)

        let logo = UIImageView(image: UIImage(named: "logoName"))
        logo.contentMode = .scaleAspectFit
        addSubview(logo, anchors: [.top(100), .centerX(0), .width(85), .height(50)])

        addSubview(collectionView, anchors: [.centerY(0), .trailing(-10),
                                             .leading(10), .height(UIScreen.main.bounds.height / 2)])

        historyButton.backgroundColor = .systemRed.withAlphaComponent(0.1)
        historyButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        historyButton.tintColor = .systemRed
        historyButton.layer.cornerRadius = 25
        historyButton.imageView?.contentMode = .scaleAspectFit
        historyButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addSubview(historyButton, anchors: [.width(50), .height(50), .top(60), .leading(30)])
        historyButton.addTarget(self, action: #selector(pressHistoryButton), for: .touchUpInside)

        let nextButton = UIButton()
        nextButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        nextButton.setTitle("START", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "BMJUA", size: 28)
        nextButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        addSubview(nextButton, anchors: [.trailing(-50), .leading(50)])
        nextButton.attach(.top, to: collectionView, constant: 50)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }

    @objc
    private func nextButtonAction(){
        onNextButtonTapped?()
    }

    @objc
    private func pressAuthButton() {
        onAuthButtonTapped?()
    }

    @objc
    private func pressHistoryButton() {
        onHistoryButtonTapped?()
    }

    func updateAuthButtonUI(_ state: Bool) {
        if state {
            authButton.setTitle(nil, for: .normal)
            authButton.setAttributedTitle(nil, for: .normal)
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
            let profileImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig)
            authButton.setImage(profileImage, for: .normal)
            authButton.tintColor = DiggerColor.mainTextColor
        } else {
            authButton.setImage(nil, for: .normal)
            let loginAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "BMJUA", size: 18) ?? UIFont.systemFont(ofSize: 18),
                .foregroundColor: DiggerColor.mainTextColor,
                .baselineOffset: 2
            ]
            let loginString = NSAttributedString(string: "Login", attributes: loginAttributes)
            authButton.setAttributedTitle(loginString, for: .normal)

            authButton.menu = nil
            authButton.showsMenuAsPrimaryAction = false
        }
    }

    func setupProfileMenu(name: String) {
        let displayNameAction = UIAction(title: name, handler: {_ in })
        let editPasswordAction = UIAction(title: "Edit password", image: UIImage(systemName: "lock.fill"), handler: { _ in
            self.onChangePasswordTapped?()
        })
        let logoutImage = UIImage(systemName: "arrow.right.square")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let logoutAction = UIAction(title: "Logout", image: logoutImage, handler: { _ in
            self.onLogoutTapped?()
        })

        let rootMenu = UIMenu(title: "", options: .displayInline, children: [displayNameAction, editPasswordAction, logoutAction])

        authButton.menu =  rootMenu
        authButton.showsMenuAsPrimaryAction = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CuisineCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = DiggerColor.mainBackgroundColor
        let layout = UICollectionViewFlowLayout()
        let cellSize = UIScreen.main.bounds.width / 4
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionViewLayout = layout

        register(CuisineCell.self, forCellWithReuseIdentifier: "cuisineCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CuisineCell: UICollectionViewCell {
    let thumbnailImg = UIImageView()
    let thumbnail = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DiggerColor.cellColor
        layer.borderWidth = 2
        layer.borderColor = DiggerColor.headColor.cgColor
        layer.cornerRadius = 10.0
        thumbnailImg.contentMode = .scaleAspectFit
        thumbnailImg.clipsToBounds = true
        addSubview(thumbnailImg, anchors: [.centerX(0), .centerY(0), .width(frame.size.width)])
        addSubview(thumbnail, anchors: [.centerX(0), .bottom(-10), .width(frame.size.width)])
        thumbnail.textColor = DiggerColor.mainTextColor
        thumbnail.textAlignment = .center
        thumbnail.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
