//
//  FoodListView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

protocol FoodListViewDelegate: AnyObject {
    func didPressHomeButton(sender: UIButton)
    func didPressMapButton(sender: UIButton)
    func didPressAddButton(sender: UIButton)
    func didPressRandomButton(sender:UIButton)
}

class FoodListView: UIView {

    weak var delegate: FoodListViewDelegate?

    let title = UILabel()
    let header = HeaderStackView()
    let textField = UITextField()
    let nextButton = UIButton()
    let restuarantList = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor
        title.textAlignment = .center
        title.textColor = DiggerColor.mainTextColor
        title.numberOfLines = 2

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.addTarget(self, action: #selector(pressHomeButton), for: .touchUpInside)

        let mapButton = UIButton()
        mapButton.setImage(UIImage(named: "map"), for: .normal)
        mapButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mapButton.addTarget(self, action: #selector(pressMapButton), for: .touchUpInside)

        //Header
        addSubview(header, anchors: [.leading(0), .trailing(0), .top(0), .height(100)])
        header.addArrangedSubview(backButton)
        header.addArrangedSubview(title)
        header.addArrangedSubview(mapButton)

        let textfieldBackgound = UIView()
        addSubview(textfieldBackgound, anchors: [.leading(0), .trailing(0), .height(57)])
        textfieldBackgound.backgroundColor = DiggerColor.textFieldColor
        textfieldBackgound.attach(.bottom, to: title, constant: 50)

        textfieldBackgound.addSubview(textField, anchors: [.top(0), .trailing(-55), .bottom(0), .leading(10)])
        textField.backgroundColor = DiggerColor.textFieldColor
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("placeholder", comment: ""),
                                                             attributes: [NSAttributedString.Key.foregroundColor: DiggerColor.mainTextColor])
        textField.textColor = DiggerColor.mainTextColor
        textField.keyboardType = .default
        textField.returnKeyType = .done

        let addButton = UIButton()
        addButton.setImage(UIImage(named: "textAdd"), for: .normal)
        addButton.backgroundColor = DiggerColor.textFieldColor
        textfieldBackgound.addSubview(addButton, anchors: [.top(10), .trailing(-20), .width(35), .height(35)])
        addButton.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)

        //next button
        addSubview(nextButton, anchors: [.trailing(-50), .bottom(-40), .leading(50)])
        nextButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        nextButton.setTitle("GET", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "BMJUA", size: 28)
        nextButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(pressRandomButton), for: .touchUpInside)

        // list collection view
        addSubview(restuarantList, anchors: [.leading(10), .trailing(-10)])
        restuarantList.attach(.bottom, to: textField, constant: 60)
        restuarantList.attach(.top, to: nextButton, constant: -40)
        restuarantList.backgroundColor = .clear
        restuarantList.register(RestaurantListCell.self, forCellWithReuseIdentifier: "customCell")
    }

    @objc
    func pressHomeButton(sender: UIButton) {
        delegate?.didPressHomeButton(sender: sender)
    }

    @objc
    func pressMapButton(sender: UIButton) {
        delegate?.didPressMapButton(sender: sender)
    }

    @objc
    func pressAddButton(sender: UIButton) {
        delegate?.didPressAddButton(sender: sender)
    }

    @objc
    func pressRandomButton(sender: UIButton) {
        delegate?.didPressRandomButton(sender: sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HeaderStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.headColor
        alignment = .center
        axis = .horizontal
        distribution = .fillProportionally
        spacing = 20
        layoutMargins = UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20)
        isLayoutMarginsRelativeArrangement = true
        insetsLayoutMarginsFromSafeArea = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RestaurantListCell: UICollectionViewCell {

    let nameLabel =  UILabel()
    let deleteButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DiggerColor.textFieldColor
        nameLabel.textAlignment = .left
        nameLabel.textColor = DiggerColor.mainTextColor
        addSubview(nameLabel, anchors: [.centerX(0), .centerY(0)])

        deleteButton.setImage(UIImage(named: "close"), for: .normal)
        addSubview(deleteButton, anchors: [.top(10), .trailing(-20), .width(33), .height(33)])

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
