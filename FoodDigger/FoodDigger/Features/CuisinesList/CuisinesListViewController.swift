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
        cuisinesListView.collectionView.delegate = self
        cuisinesListView.collectionView.dataSource = self
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

extension CuisinesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisineCell",
                                                            for: indexPath) as? CuisineCell else { return UICollectionViewCell() }

        cell.thumbnail.text = "\(indexPath.row)"
        return cell
    }
}
