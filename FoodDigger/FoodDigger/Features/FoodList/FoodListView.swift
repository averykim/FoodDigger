//
//  FoodListView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

protocol FoodListViewDelegate: AnyObject {
}

class FoodListView: UIView {

    weak var delegate: FoodListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white

        let title = UILabel()
        title.text = "Food List"
        title.textAlignment = .center
        title.textColor = .brown
        addSubview(title, anchors: [.top(50), .centerX(0), .width(100), .height(50)])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
