//
//  CurrencyRateViewCell.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import UIKit

class CurrencyRateViewCell: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    func configure(rate: Double, currency: String) {
        amount.text = String(rate)
        self.currency.text = currency
    }
}
