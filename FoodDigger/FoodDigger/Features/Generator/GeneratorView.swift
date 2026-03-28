//
//  Generator.swift
//  FoodDigger
//
//  Created by JihyeKim on 1/19/26.
//

import UIKit

protocol GeneratorViewDelegate: AnyObject {
    func didPressHomeButton(sender:UIButton)
}

class Generatorview: UIView {

    weak var delegate: GeneratorViewDelegate?

    let resultBox = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor

        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(closeButton, anchors: [.top(100), .trailing(-50)])
        closeButton.addTarget(self, action: #selector(pressHomeButton), for: .touchUpInside)

        resultBox.backgroundColor = DiggerColor.cellColor
        resultBox.widthAnchor.constraint(equalToConstant: 335).isActive = true
        resultBox.heightAnchor.constraint(equalToConstant: 209).isActive = true
        resultBox.numberOfLines = 0
        resultBox.layer.cornerRadius = 10.0
        resultBox.clipsToBounds = false
        resultBox.textColor = DiggerColor.mainTextColor
        resultBox.textAlignment = .center
        resultBox.font = UIFont(name: "BMJUA", size: 28)
        addSubview(resultBox, anchors: [.centerX(0), .centerY(0)])

        let cheeseImg = UIImageView(image: UIImage(named: "cheese"))
        cheeseImg.widthAnchor.constraint(equalToConstant: 62).isActive = true
        cheeseImg.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cheeseImg.contentMode = .scaleAspectFit
        resultBox.addSubview(cheeseImg, anchors: [.top(-20), .centerX(0)])

        let shadowView = UIImageView(image: UIImage(named: "cheeseShadow"))
        shadowView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resultBox.addSubview(shadowView, anchors: [.centerX(0), .bottom(80)])
    }

    @objc
    func pressHomeButton(sender: UIButton) {
        delegate?.didPressHomeButton(sender:sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
