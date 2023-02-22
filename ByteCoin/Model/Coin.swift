import Foundation

struct Coin: Decodable {
    let time: String
    let base: String
    let quote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
           case time
           case base = "asset_id_base"
           case quote = "asset_id_quote"
           case rate
       }
}
