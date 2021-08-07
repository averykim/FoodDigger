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

        let mapButton = UIButton()
        addSubview(mapButton, anchors: [.top(50), .trailing(-30), .width(40), .height(40)])
        mapButton.layer.cornerRadius = 10
        mapButton.backgroundColor = .systemPink
        mapButton.addTarget(self, action: #selector(pressMapButton), for: .touchUpInside)
    }

    @objc
    func pressHomeButton(sender: UIButton) {
        delegate?.didPressHomeButton(sender: sender)
    }

    @objc
    func pressMapButton(sender: UIButton) {
        delegate?.didPressMapButton(sender: sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
