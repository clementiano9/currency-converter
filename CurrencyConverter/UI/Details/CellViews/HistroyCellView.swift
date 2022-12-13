//
//  HistroyCellView.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import UIKit

class HistoryCellView: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func configure(rate: Double, date: String) {
        amount.text = "\(rate)"
        self.date.text = date
    }
}
