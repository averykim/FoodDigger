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

    private let generator = UIImpactFeedbackGenerator(style: .medium)

    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        foodListView.textField.delegate = self
        foodListView.restuarantList.delegate = self
        foodListView.restuarantList.dataSource = self
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
        foodListView.title.text = viewModel.cuisine
        bindViewModel()
        bind()
    }

    private func bindViewModel() {
        viewModel.onRestaurantsUpdated = {[weak self] in
            DispatchQueue.main.async {
                self?.foodListView.restuarantList.reloadData()
                if !(self?.viewModel.restaurants.isEmpty ?? false) {
                    self?.foodListView.nextButton.isEnabled = true
                }
            }
        }
    }

    private func bind() {
        foodListView.onHomeButtonTapped = {[weak self] in self?.viewModel.moveToCuisineListView()
        }
        foodListView.onNextButtonTapped = {[weak self] in self?.viewModel.moveToGeneratorView()
        }
        foodListView.onMapButtonTapped = {[weak self] in self?.viewModel.moveToMapView()}
        foodListView.onAddeButtonTapped = {[weak self] in
            self?.viewModel.addRestaurant(name: self?.foodListView.textField.text ?? "")
            self?.foodListView.textField.text = nil
        }
    }
}

extension FoodListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        viewModel.addRestaurant(name: foodListView.textField.text ?? "")
        foodListView.textField.text = nil
        return true
    }
}

extension FoodListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.restaurants.count
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
        cell.nameLabel.text = "\(viewModel.restaurants[indexPath.row].name)"
        cell.toggleHeartButton(viewModel.restaurants[indexPath.row].isSaved)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        cell.heartButton.tag = indexPath.row
        cell.heartButton.addTarget(self, action: #selector(heartCell(sender:)), for: .touchUpInside)
        return cell
    }

    @objc
    func heartCell(sender: UIButton) {
        generator.impactOccurred()
        viewModel.toggleSave(at: sender.tag)
    }

    @objc
    func deleteCell(sender: UIButton) {
        viewModel.deleteRestaurant(at: sender.tag)
    }
}
