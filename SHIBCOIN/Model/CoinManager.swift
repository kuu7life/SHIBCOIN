//
//  CoinManager.swift
//  SHIBCOIN
//
//  Created by Kutman Amangeldiev on 2022/4/29.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/SHIB"
    let apiKey = "D7492C76-7D7F-430A-87C3-797E4AE8998A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let shibaPrice = self.parseJson(data: safeData) {
                        let priceString = String(format: "%.8f", shibaPrice)
                        delegate?.didUpdatePrice(self, price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

