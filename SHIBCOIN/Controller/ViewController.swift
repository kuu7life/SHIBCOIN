//
//  ViewController.swift
//  SHIBCOIN
//
//  Created by Kutman Amangeldiev on 2022/4/28.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currenclyLabel: UILabel!
    @IBOutlet weak var currencypicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencypicker.delegate = self
        currencypicker.dataSource = self
    }
}

//MARK: - UIPickerView Data Source & UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = price
            self.currenclyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
