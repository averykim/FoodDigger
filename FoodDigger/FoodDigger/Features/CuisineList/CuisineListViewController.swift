//
//  ViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/15.
//

import UIKit

class CuisineListViewController: UIViewController {

    let cuisineListView = CuisineListView()
    let viewModel: CuisineListViewModel

    init(viewModel: CuisineListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cuisineListView.delegate = self
        cuisineListView.collectionView.delegate = self
        cuisineListView.collectionView.dataSource = self
    }

    override func loadView() {
        super.loadView()
        view = cuisineListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initializeDict()
        cuisineListView.collectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CuisineListViewController: CuisineListViewDelegate {
    func didPressHelpButton(sender: UIButton) {
        viewModel.moveToHelpView()
    }

    func didPressNextButton(sender: UIButton) {
        viewModel.moveToFoodListView()
    }
}

extension CuisineListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CuisineType.cases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisineCell",
                                                            for: indexPath) as? CuisineCell else { return UICollectionViewCell() }

        let cuisineType = NSLocalizedString(CuisineType.cases[indexPath.row].rawValue, comment: "")
        cell.thumbnail.text = "\(cuisineType)"

        if viewModel.cuisines[CuisineType.cases[indexPath.row]] == cuisineType {
            cell.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectType = CuisineType.cases[indexPath.row]
        viewModel.changeCuisinesState(type: selectType)
        collectionView.reloadData()
    }
}
