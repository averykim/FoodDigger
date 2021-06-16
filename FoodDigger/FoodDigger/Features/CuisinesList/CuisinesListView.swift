//
//  CuisineView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import UIKit

class CuisinesListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)

        let logo = UILabel()
        logo.text = "Food Digger"
        logo.textAlignment = .center
        logo.textColor = .brown
        addSubview(logo, anchors: [.top(100), .centerX(0), .width(100), .height(50)])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
