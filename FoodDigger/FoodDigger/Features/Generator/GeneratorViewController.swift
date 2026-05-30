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
    }

    override func loadView() {
        super.loadView()
        view = generatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
        viewModel.randomResult()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.onRandomResultUpdated = {[weak self] result in
            self?.generatorView.scrathCard.setResutlText(result)
        }
    }

    private func bindView() {
        generatorView.onHomeButtonTapped = { [weak self] in self?.viewModel.moveToHome()}
        generatorView.scrathCard.onScratchFinished = {[weak self] in
            self?.generatorView.updateTitle()
        }
        generatorView.onReplayButtonTapped = {[weak self] in
            self?.generatorView.scrathCard.resetScratch()
            self?.viewModel.randomResult()
        }
        generatorView.onGoButtonTapped = {[weak self] in
            self?.viewModel.moveToExternalMap()
        }
    }
}
