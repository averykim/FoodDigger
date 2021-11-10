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
