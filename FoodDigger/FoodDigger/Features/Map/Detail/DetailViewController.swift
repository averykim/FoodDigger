//
//  DetailViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/16/26.
//

import UIKit

class DetailViewController: UIViewController {

    let detailView = DetailView()
    let viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
