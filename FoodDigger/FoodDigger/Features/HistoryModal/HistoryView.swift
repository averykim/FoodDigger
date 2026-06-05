//
//  HistoryView.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/20/26.
//

import UIKit

class HistoryView: UIView {

    var onCloseTapped: (() -> Void)?

    let tableView = UITableView(frame: .zero, style: .plain)
    let emptyLabel = UILabel()
    let closeButton = UIButton()

    let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = DiggerColor.mainBackgroundColor
        let title = UILabel()
        title.font = UIFont(name: "BMJUA", size: 25)
        title.textColor = DiggerColor.mainTextColor
        title.text = "My Digs❤️"
        addSubview(title, anchors: [.top(60), .centerX(0), .height(50)])

        tableView.backgroundColor = DiggerColor.mainBackgroundColor
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 104
        addSubview(tableView, anchors: [.top(150), .leading(10), .trailing(-10), .bottom(50)])
        tableView.register(HistoryTableCell.self, forCellReuseIdentifier: "historyCell")

        emptyLabel.text = "No history"
        emptyLabel.textColor = DiggerColor.mainTextColor
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyLabel, anchors: [.centerX(0), .centerY(0)])

        let closeButton = UIButton()
        closeButton.backgroundColor = DiggerColor.textFieldColor
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton, anchors: [.top(50), .trailing(-30), .width(40), .height(40)])
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)

        addSubview(activityIndicator, anchors: [.centerX(0), .centerY(0)])
        bringSubviewToFront(activityIndicator)
        activityIndicator.color = .darkGray
    }

    @objc
    private func pressCloseButton() {
        onCloseTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HistoryTableCell: UITableViewCell {
    private let thumbnailImageView = CacheImageView()
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let addressLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        let containerView  = UIView()
        containerView.backgroundColor = DiggerColor.textBoxColor
        containerView.layer.cornerRadius = 10
        addSubview(containerView,  anchors: [.top(5), .bottom(-5), .leading(0), .trailing(0)])

        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.backgroundColor = DiggerColor.textBoxColor
        containerView.addSubview(thumbnailImageView, anchors: [.width(80), .height(80), .top(5), .leading(10), .bottom(-5)])

        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textColor = DiggerColor.mainTextColor
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8

        ratingLabel.font = .systemFont(ofSize: 14)
        ratingLabel.textColor = DiggerColor.mainTextColor

        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = DiggerColor.placeholderColor
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.numberOfLines = 2

        let stackView =  UIStackView(arrangedSubviews: [nameLabel, ratingLabel, addressLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView, anchors: [.top(5), .bottom(-12), .leading(100), .trailing(-10)])
    }


    func updateData(with model: HistoryModel) {
        nameLabel.text = model.name
        addressLabel.text = model.address
        if model.isCustom {
            ratingLabel.text = ""
        } else {
            ratingLabel.text = "\(model.rating ?? 0.0)"
        }

        if let urlString = model.imageUrl, !urlString.isEmpty {
            thumbnailImageView.loadImage(from: urlString)
        } else {
            thumbnailImageView.image = UIImage(named: "logo")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
