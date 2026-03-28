//
//  Untitled.swift
//  FoodDigger
//
//  Created by JihyeKim on 3/24/26.
//
import UIKit

class GeneratorViewController: UIViewController {

    let generatorView = Generatorview()
    let viewModel: GeneratorViewModel

    init(viewModel: GeneratorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        generatorView.delegate = self
    }

    override func loadView() {
        super.loadView()
        view = generatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        generatorView.resultBox.text = viewModel.randomResult()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GeneratorViewController: GeneratorViewDelegate {
    func didPressHomeButton(sender:UIButton) {
        viewModel.moveToHome()
    }
}
