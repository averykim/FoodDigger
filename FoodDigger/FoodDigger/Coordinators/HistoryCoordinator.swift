//
//  Untitled.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/20/26.
//

import UIKit

class HistoryCoordinator: Coordinator {

    var historyModalDidFinish: (() -> Void)?

//    override init(navigationController: UINavigationController) {
//        super.init(navigationController: navigationController)
//    }
    func start() {
        let historyViewModel = HistoryViewModel()
        let historyViewController  = HistoryViewController(viewModel: historyViewModel)
        historyViewController.modalPresentationStyle = .fullScreen
        historyViewController.modalTransitionStyle = .crossDissolve

        historyViewModel.dismissHistoryView = {[weak self] in
            self?.navigationController.dismiss(animated: true, completion: nil)
            self?.historyModalDidFinish?()
        }
        navigationController.present(historyViewController, animated: false, completion: nil)
    }
}
