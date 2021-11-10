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
}

class FoodListView: UIView {

    weak var delegate: FoodListViewDelegate?

    let title = UILabel()
    let header = HeaderStackView()
    let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        title.textAlignment = .center
        title.textColor = .brown
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
        textfieldBackgound.backgroundColor = .white
        textfieldBackgound.attach(.bottom, to: title, constant: 50)

        textfieldBackgound.addSubview(textField, anchors: [.top(0), .trailing(-55), .bottom(0), .leading(10)])
        textField.backgroundColor = .white
        textField.placeholder = NSLocalizedString("placeholder", comment: "")
        textField.keyboardType = .default
        textField.returnKeyType = .default

        let addButton = UIButton()
        addButton.setImage(UIImage(named: "textAdd"), for: .normal)
        textfieldBackgound.addSubview(addButton, anchors: [.top(10), .trailing(-20), .width(35), .height(35)])
        addButton.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HeaderStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 1.00, green: 0.82, blue: 0.29, alpha: 1.00)
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
