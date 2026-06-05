//
//  MapView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit
import GoogleMaps

class MapView: UIView {

    var onCloseTapped: (() -> Void)?
    let googleMap = GMSMapView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        googleMap.mapType = .normal
        addSubview(googleMap, anchors: [.top(0), .trailing(0), .bottom(0), .leading(0)])

        let closeButton = UIButton()
        closeButton.backgroundColor = DiggerColor.textFieldColor
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton, anchors: [.top(50), .trailing(-30), .width(40), .height(40)])
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
    }

    @objc
    func pressCloseButton() {
        onCloseTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapMarkerInfoWindow: UIView {

    let nameLabel = UILabel()
    let ratingLabel = UILabel()
    let addressLabel = UILabel()
    let addButton = UIButton()

    var onAddTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear

        //name label
//        addSubview(nameLabel, anchors: [.top(10), .leading(15), .width(124), .height(17)])
        nameLabel.textAlignment = .left
        nameLabel.textColor = DiggerColor.mainTextColor
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 2
        nameLabel.clipsToBounds = true
        //rating label
//        addSubview(ratingLabel, anchors: [.top(30), .leading(15), .width(124), .height(17)])
        ratingLabel.textAlignment = .left
        ratingLabel.textColor = DiggerColor.mainTextColor
        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.numberOfLines = 1
        ratingLabel.clipsToBounds = true
        //addressLabel
//        addSubview(addressLabel, anchors: [.bottom(-20), .leading(15), .width(200), .height(17)])
        addressLabel.textAlignment = .left
        addressLabel.textColor = DiggerColor.mainTextColor
        addressLabel.font = .systemFont(ofSize: 14, weight: .regular)
        addressLabel.numberOfLines = 3
        addressLabel.clipsToBounds = true

        //add button
//        addSubview(addButton, anchors: [.top(10), .trailing(-15), .width(31), .height(31)])
        addButton.setImage(UIImage(named: "markerAdd"), for: .normal)
        addButton.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
        addButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false

        let textStatckView = UIStackView(arrangedSubviews: [nameLabel, ratingLabel, addressLabel])
        textStatckView.axis = .vertical
        textStatckView.spacing = 4
        textStatckView.alignment = .fill

        let mainStackView = UIStackView(arrangedSubviews: [textStatckView, addButton])
        mainStackView.axis = .horizontal
        mainStackView.spacing =  16
        mainStackView.alignment = .center
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        mainStackView.isLayoutMarginsRelativeArrangement = true

        addSubview(mainStackView, anchors: [.leading(3), .trailing(-3), .top(0), .bottom(-3)])
        mainStackView.backgroundColor = DiggerColor.mainBackgroundColor
        mainStackView.layer.cornerRadius = 12
        mainStackView.layer.shadowColor = UIColor.black.cgColor
        mainStackView.layer.shadowOpacity = 0.15
        mainStackView.layer.shadowOffset = .init(width: 0, height: 4)
        mainStackView.layer.shadowRadius = 8
    }

    func updateData(with restaurant: RestaurantModel) {
        nameLabel.text = restaurant.name
        ratingLabel.text = "⭐️ \(restaurant.rating, default: "")"
        addressLabel.text = restaurant.address
    }

    @objc
    func pressAddButton() {
        onAddTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
