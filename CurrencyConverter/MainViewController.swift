//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    let currencyPicker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        setupDropdowns()
        
    }

    func setupDropdowns() {
        fromView.layer.borderColor = UIColor.systemGray5.cgColor
        toView.layer.borderColor = UIColor.systemGray5.cgColor
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        fromTextField.inputView = currencyPicker
        toTextField.inputView = currencyPicker
        
        fromTextField.inputAccessoryView = UIToolbar.createWithDoneButton(target: self, doneAction: #selector(donePressed))
        toTextField.inputAccessoryView = UIToolbar.createWithDoneButton(target: self, doneAction: #selector(donePressed))
         
    }
    
    @objc
    func donePressed() {
        if fromTextField.isFirstResponder {
            fromTextField.resignFirstResponder()
        } else if toTextField.isFirstResponder {
            toTextField.resignFirstResponder()
        }
    }
}

// MARK: Picker
extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "NGN"
    }
    
}

// MARK: - Currency picker datasource and delegate

class CurrencyDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let options = ["NGN", "USD"]
    var selectionHandler: ((String) -> Void)?   // TODO: Remove and add lamdba to constructor
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "NGN"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionHandler?(options[row])
    }
}

// MARK: - TextField delegate
extension MainViewController: UITextFieldDelegate {
    
}


// MARK: - UIToolbar
extension UIToolbar {
    static func createWithDoneButton(target: Any, doneAction: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let doneAction = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneAction)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneAction], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor = UIColor(named: "primaryColor")
        toolbar.sizeToFit()
        return toolbar
    }
}
