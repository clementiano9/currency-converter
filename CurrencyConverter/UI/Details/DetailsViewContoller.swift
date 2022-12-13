//
//  DetailsViewContoller.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import UIKit

protocol DetailsViewDisplayLogic {
    func detailsLoading()
    func detailsSuccess()
    func detailsLoadingFailure(error: Error)
    
}

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var currenciesTableView: UITableView!
    
    var source: String = ""
    var target: String = ""
    var rates: [String: Double] = [:]
    
    lazy var viewModel: DetailsViewModel = {
        return DetailsViewModel(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getHistoricalData(source: source, target: target)
        setupTableViews()
    }
    
    private func setupTableViews() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        currenciesTableView.delegate = self
        currenciesTableView.dataSource = self
    }
}

// MARK: - TableView delegate and datasource
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == historyTableView) {
            return viewModel.data.count
        } else if (tableView == currenciesTableView) {
            return rates.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == historyTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCellView
            let item = viewModel.data[indexPath.row]
            cell.configure(rate: item.rates.values.first ?? 0.0, date: item.date)
            return cell
        } else if (tableView == currenciesTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "currencyRateViewCell", for: indexPath) as! CurrencyRateViewCell
            let key = Array(rates.keys)[indexPath.row]
            let item = rates[key] ?? 0
            cell.configure(rate: item, currency: key)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == historyTableView) {
            return "Historical data"
        } else {
            return "Other currencies"
        }
    }
}

// MARK: - Presentation logic

extension DetailsViewController: DetailsViewDisplayLogic {
    
    func detailsLoading() {
        
    }
    
    func detailsSuccess() {
        historyTableView.reloadData()
    }

    func detailsLoadingFailure(error: Error) {
        displayAlertMessage(message: error.localizedDescription)

    }
}
