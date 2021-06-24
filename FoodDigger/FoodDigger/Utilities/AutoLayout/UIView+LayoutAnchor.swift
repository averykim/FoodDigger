//
//  UIView+LayoutAnchor.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import UIKit

extension UIView {
    func addSubview(_ subview: UIView, anchors: [LayoutAnchor]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.activate(anchors: anchors, relativeTo: self)
    }

    func activate(anchors: [LayoutAnchor], relativeTo item: UIView? = nil) {
        let constraints = anchors.map { NSLayoutConstraint(from: self, to: item, anchor: $0) }
        NSLayoutConstraint.activate(constraints)
    }

    enum AttachPositon {
        case top
        case trailing
        case bottom
        case leading
    }

    func attach(_ position: AttachPositon, to ofElement: UIView, constant: CGFloat = 0) {
        switch position {
        case .top:
            bottomAnchor.constraint(equalTo: ofElement.bottomAnchor, constant: constant).isActive = true
        case .trailing:
            leadingAnchor.constraint(equalTo: ofElement.leadingAnchor, constant: constant).isActive = true
        case .bottom:
            topAnchor.constraint(equalTo: ofElement.topAnchor, constant: constant).isActive = true
        case .leading:
            trailingAnchor.constraint(equalTo: ofElement.trailingAnchor, constant: constant).isActive = true
        }
    }
}
