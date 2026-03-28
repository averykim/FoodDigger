//
//  GeneratorCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/27.
//

import UIKit

protocol GeneratorCoordinatorDelegate: AnyObject {
    func generatorCoordinatorDidFinish()
}

class GeneratorCoordinator: Coordinator {

    weak var delegate: GeneratorCoordinatorDelegate?

    let cuisineList:[String]

    init(navigationController: UINavigationController, cuisineList: [String]) {
        self.cuisineList = cuisineList
        super.init(navigationController: navigationController)
    }

    private var generatorViewModel: GeneratorViewModel?

    func start() {
        generatorViewModel = GeneratorViewModel(cuisineList: cuisineList)
        generatorViewModel?.delegate = self
        let generatorViewController = GeneratorViewController(viewModel: generatorViewModel ??
                                                              GeneratorViewModel(cuisineList: cuisineList))
        navigationController.pushViewController(generatorViewController, animated: true)
    }
    
}

extension GeneratorCoordinator: GeneratorViewModelDelegate {
    func goToHome() {
        delegate?.generatorCoordinatorDidFinish()
    }
}
