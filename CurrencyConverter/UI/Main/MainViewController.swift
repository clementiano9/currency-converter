//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya
//

import UIKit
import RxSwift

// MARK: - MainViewDisplayLogic protocol
protocol MainViewDisplayLogic {
    func mainDataLoading()
    func mainDataLoadingFailure(error: Error)
    func mainDataLoadingSuccess()
    
    func conversionFinished(amount: String)
    func conversionFailed(error: Error)
}


// MARK: - MainViewController
class MainViewController: UIViewController {

    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var convertedField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let currencyPicker = UIPickerView()
    
    lazy var viewModel: MainViewModel = {
        return MainViewModel(delegate: self)
    }()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        setupDropdowns()
        viewModel.getSymbols()
        observeCurrencySelectionChanges()
    }
    
    func observeCurrencySelectionChanges() {
        // Observe currencies selected from the viewModel and sets their textFields
        viewModel.fromCurrency
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.fromTextField.text = $0
            }.disposed(by: bag)

        viewModel.toCurrenccy
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.toTextField.text = $0
            }.disposed(by: bag)
    }

    /// Setup the currency dropdown, opens up a picker to choose a currency
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
        // Set the currency selected to the appropiate currency field
        if fromTextField.isFirstResponder {
            fromTextField.resignFirstResponder()
            guard let key = viewModel.getSymbolAtIndex(pos: currencyPicker.selectedRow(inComponent: 0)) else { return }
            viewModel.fromCurrency.accept(key)
        } else if toTextField.isFirstResponder {
            toTextField.resignFirstResponder()
            guard let key = viewModel.getSymbolAtIndex(pos: currencyPicker.selectedRow(inComponent: 0)) else { return }
            viewModel.toCurrenccy.accept(key)
        }
    }
    
    @IBAction func amountChanged(_ sender: UITextField) {
        viewModel.setSourceValue(sender.text ?? "")
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        viewModel.switchCurrencies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let dest = segue.destination as? DetailsViewController {
            dest.source = viewModel.fromCurrency.value
            dest.target = viewModel.toCurrenccy.value
            dest.rates = viewModel.rates
        }
    }
}

// MARK: - Picker delegate and datasource
extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.symbols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let key = viewModel.getSymbolAtIndex(pos: row) {
            return "\(key) - \(viewModel.symbols[key] ?? "")"
        } else {
            return nil
        }
    }
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

// MARK: - Display logic delegate
extension MainViewController: MainViewDisplayLogic {
    func mainDataLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fromTextField.isEnabled = false
    }
    
    func mainDataLoadingFailure(error: Error) {
        activityIndicator.isHidden = true
        displayAlertMessage(message: error.localizedDescription)
    }
    
    func mainDataLoadingSuccess() {
        activityIndicator.isHidden = true
        fromTextField.isEnabled = true
    }
    
    func conversionFinished(amount: String) {
        convertedField.text = amount
    }
    
    func conversionFailed(error: Error) {
        
    }
}
