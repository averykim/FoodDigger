//
//  FoodListViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

class FoodListViewController: UIViewController {

    let foodListView = FoodListView()
    let viewModel: FoodListViewModel
    private let countryCode = NSLocale.current.regionCode

    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        foodListView.delegate = self
        foodListView.textField.delegate = self
        foodListView.restuarantList.delegate = self
        foodListView.restuarantList.dataSource = self
        viewModel.observer = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = foodListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        foodListView.title.text = viewModel.cuisineName
        guard let country = countryCode else { return }
        if country == "US" {
            viewModel.callYelpAPI()
        } else {
            viewModel.callKakaoAPI()
        }
    }
}

extension FoodListViewController: FoodListViewDelegate, UITextFieldDelegate {
    func didPressMapButton(sender: UIButton) {
        viewModel.moveToMapView()
    }

    func didPressHomeButton(sender: UIButton) {
        viewModel.moveToCuisineListView()
    }

    func didPressAddButton(sender: UIButton) {
        viewModel.addMenu(text: foodListView.textField.text)
        foodListView.textField.text = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

extension FoodListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedRestaurant.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? RestaurantListCell else {
            return UICollectionViewCell()
        }
        cell.nameLabel.text = "\(viewModel.selectedRestaurant[indexPath.row])"
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        return cell
    }

    @objc
    func deleteCell(sender: UIButton) {
        viewModel.deleteMenu(menuIndex: sender.tag)
    }
}

extension FoodListViewController: FoodListViewModelObserver {
    func updateSelectedInfo() {
        foodListView.restuarantList.reloadData()
    }
}
