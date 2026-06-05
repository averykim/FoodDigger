//
//  DetailViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/16/26.
//

import UIKit

class DetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .lightGray
        //ADD BUTTON 추가하고 close button대신 밖에 화면 tap하면 내려가는걸로

        let closeButton = UIButton()
        closeButton.backgroundColor = DiggerColor.textFieldColor
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton, anchors: [.top(50), .trailing(-30), .width(40), .height(40)])
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
    }

    @objc
    func pressCloseButton() {
//        onCloseTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
