//
//  ViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/15.
//

import UIKit

class CuisinesListViewController: UIViewController {

    let cuisinesListView = CuisinesListView()
    let viewModel: CuisinesListViewModel

    init(viewModel: CuisinesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = cuisinesListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

