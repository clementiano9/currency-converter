//
//  Ext + UIViewController.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
