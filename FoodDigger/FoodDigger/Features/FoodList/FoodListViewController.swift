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

    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        foodListView.delegate = self
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
    }
}

extension FoodListViewController: FoodListViewDelegate {
    func didPressHomeButton(sender: UIButton) {
        viewModel.moveToCuisineListView()
    }
}
