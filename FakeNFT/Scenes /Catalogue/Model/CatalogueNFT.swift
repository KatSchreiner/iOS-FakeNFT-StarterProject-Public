import Foundation

struct CatalogueNFT: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
