import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "84C84E62-FF94-4B2B-82B4-C5CAE239254E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        Task {
            try await performRequest(with: url)
        }
    }
    
    func performRequest(with urlString: String) async throws {
        guard let url = URL(string: urlString) else { return }
        do {
           let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            guard let coin = try? JSONDecoder().decode(Coin.self, from: data) else { return }
            delegate?.didUpdatePrice(price: String(format: "%0.2f", coin.rate), currency: coin.quote)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
