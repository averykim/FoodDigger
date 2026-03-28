//
//  CuisineView.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import UIKit

protocol CuisineListViewDelegate: AnyObject {
    func didPressHelpButton(sender: UIButton)
    func didPressNextButton(sender: UIButton)
}

class CuisineListView: UIView {

    weak var delegate: CuisineListViewDelegate?
    let collectionView = CuisineCollectionView(frame: .zero,
                                                           collectionViewLayout: UICollectionViewFlowLayout())
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor

//        let helpButton = UIButton()
//        helpButton.backgroundColor = .darkGray
//        helpButton.layer.cornerRadius = 10
//        addSubview(helpButton, anchors: [.top(50), .trailing(-30)])
//        helpButton.addTarget(self, action: #selector(pressHelpButton), for: .touchUpInside)

        let logo = UIImageView(image: UIImage(named: "logoName"))
        logo.contentMode = .scaleAspectFit
        addSubview(logo, anchors: [.top(100), .centerX(0), .width(85), .height(50)])
        addSubview(collectionView, anchors: [.centerY(0), .trailing(-10),
                                             .leading(10), .height(UIScreen.main.bounds.height / 2)])
        let nextButton = UIButton()
        nextButton.setBackgroundImage(UIImage(named: "buttonBackground"), for: .normal)
        nextButton.setTitle("START", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "BMJUA", size: 28)
        nextButton.setTitleColor(DiggerColor.mainTextColor, for: .normal)
        addSubview(nextButton, anchors: [.trailing(-50), .leading(50)])
        nextButton.attach(.top, to: collectionView, constant: 50)
        nextButton.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
    }

    @objc
    func pressHelpButton(sender: UIButton) {
        delegate?.didPressHelpButton(sender: sender)
    }

    @objc
    func pressNextButton(sender: UIButton) {
        delegate?.didPressNextButton(sender: sender)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CuisineCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = DiggerColor.mainBackgroundColor
        let layout = UICollectionViewFlowLayout()
        let cellSize = UIScreen.main.bounds.width / 4
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionViewLayout = layout

        register(CuisineCell.self, forCellWithReuseIdentifier: "cuisineCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CuisineCell: UICollectionViewCell {
    let thumbnailImg = UIImageView()
    let thumbnail = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DiggerColor.cellColor
        layer.borderWidth = 2
        layer.borderColor = DiggerColor.headColor.cgColor
        layer.cornerRadius = 10.0
        thumbnailImg.contentMode = .scaleAspectFit
        thumbnailImg.clipsToBounds = true
        addSubview(thumbnailImg, anchors: [.centerX(0), .centerY(0), .width(frame.size.width)])
        addSubview(thumbnail, anchors: [.centerX(0), .bottom(-10), .width(frame.size.width)])
        thumbnail.textColor = DiggerColor.mainTextColor
        thumbnail.textAlignment = .center
        thumbnail.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
