//
//  MapView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit
import GoogleMaps

protocol MapViewDelegate: AnyObject {
    func didPressCloseButton(sender: UIButton)
}

class MapView: UIView {

    weak var delegate: MapViewDelegate?

    let googleMap = GMSMapView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        googleMap.mapType = .normal
        addSubview(googleMap, anchors: [.top(0), .trailing(0), .bottom(0), .leading(0)])

        let closeButton = UIButton()
        closeButton.backgroundColor = .white
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton, anchors: [.top(50), .trailing(-30), .width(40), .height(40)])
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
    }

    @objc
    func pressCloseButton(sender: UIButton) {
        delegate?.didPressCloseButton(sender: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapMarkerInfoWindow: UIView {

    private let backgroundImage = UIImageView(image: UIImage(named: "markerInfoBox"))
    let nameLabel = UILabel()
    let addButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleToFill
        addSubview(backgroundImage, anchors: [.top(0), .trailing(0), .bottom(0), .leading(0)])
        //name label
        addSubview(nameLabel, anchors: [.top(10), .leading(15), .width(124), .height(17)])
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2
        nameLabel.clipsToBounds = true
        //add button
        addButton.setImage(UIImage(named: "markerAdd"), for: .normal)
        addSubview(addButton, anchors: [.top(5), .trailing(-15), .width(31), .height(31)])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
