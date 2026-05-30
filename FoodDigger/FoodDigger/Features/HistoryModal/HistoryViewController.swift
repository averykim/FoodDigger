//
//  HistoryViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/20/26.
//

import UIKit

class HistoryViewController: UIViewController {
    let historyView = HistoryView()
    let viewModel: HistoryViewModel

    private let generator = UINotificationFeedbackGenerator()

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        historyView.tableView.delegate = self
        historyView.tableView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = historyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchHistory()

        // bind view
        historyView.onCloseTapped = {[weak self] in self?.viewModel.closeView()}
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.historyView.emptyLabel.isHidden = !self.viewModel.histories.isEmpty
                self.historyView.tableView.reloadData()
            }
        }

        viewModel.onDeleteSuccess = {[weak self]  isSuccess in
            guard let self = self else {return}
            if isSuccess {
                self.generator.notificationOccurred(.success)
            } else {
                self.generator.notificationOccurred(.error)
            }
        }

        viewModel.onError = {[weak self] errorMsg in
            print("error: \(errorMsg)")
            self?.showAlert(message: errorMsg)
        }

        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            if isLoading {
                self?.historyView.activityIndicator.startAnimating()
            } else {
                self?.historyView.activityIndicator.stopAnimating()
                self?.historyView.activityIndicator.hidesWhenStopped = true
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableCell else {
            return UITableViewCell()
        }
        let historyData = viewModel.histories[indexPath.row]
        cell.updateData(with: historyData)

        return cell
    }

    //Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {[weak self]
            (action, view, completionHandler) in
            self?.viewModel.deleteHistory(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
