//
//  FoodListView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

protocol FoodListViewDelegate: AnyObject {
    func didPressHomeButton(sender: UIButton)
}

class FoodListView: UIView {

    weak var delegate: FoodListViewDelegate?

    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white

        title.textAlignment = .center
        title.textColor = .brown
        title.numberOfLines = 2
        addSubview(title, anchors: [.top(50), .centerX(0), .width(100), .height(50)])

        let homeButton = UIButton()
        addSubview(homeButton, anchors: [.top(50), .leading(30), .width(40), .height(40)])
        homeButton.layer.cornerRadius = 10
        homeButton.backgroundColor = .systemPink
        homeButton.addTarget(self, action: #selector(pressHomeButton), for: .touchUpInside)
    }

    @objc
    func pressHomeButton(sender: UIButton) {
        delegate?.didPressHomeButton(sender: sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
