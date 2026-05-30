//
//  HistoryViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/20/26.
//

import Foundation

class HistoryViewModel {

    var dismissHistoryView: (() -> Void)?

    var onDataUpdated: (() -> Void)?
    var onDeleteSuccess: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    private let service = HistoryService()

    var histories: [HistoryModel] = []

    func fetchHistory() {
        onLoadingStateChanged?(true)
        Task {
            do {
                let fetchedData = try await service.getHisory()
                self.histories = fetchedData

                await MainActor.run(body: {
                    self.onDataUpdated?()
                    self.onLoadingStateChanged?(false)
                })
            } catch {
                await MainActor.run(body: {
                    self.onError?("Fail to fetch history")
                    self.onLoadingStateChanged?(false)
                })
            }
        }
    }

    func deleteHistory(at index: Int) {
        guard index >= 0 && index < histories.count else { return }
        let item = histories[index]

        self.histories.remove(at: index)
        onDataUpdated?()
        Task {
            do {
                guard item.yelpId != nil || item.id != 0 else {return}
                let result = try await service.deleteHistory(yelpId: item.yelpId, historyId: item.id)

                await MainActor.run(body: {
                    self.onDeleteSuccess?(result)
                })

            } catch let error {
                await MainActor.run {
                    histories.insert(item, at: index)
                    print("chec \(error)")
                    self.onError?("Fail to delete history")
                    self.onDataUpdated?()
                }
            }
        }
    }

    func closeView() {
        dismissHistoryView?()
    }

}
