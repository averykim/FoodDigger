//
//  NSLayoutConstraint+LayoutAnchor.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import UIKit

extension NSLayoutConstraint {
    convenience init(from: UIView, to item: UIView?, anchor: LayoutAnchor) {
        switch anchor {
        case let .constant(attribute: attr, relation: relation, constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: constant
            )
        case let .relative(attribute: attr,
                           relation: relation,
                           relatedTo: relatedTo,
                           multiplier: multiplier,
                           constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: item,
                attribute: relatedTo,
                multiplier: multiplier,
                constant: constant
            )
        }
    }
}

