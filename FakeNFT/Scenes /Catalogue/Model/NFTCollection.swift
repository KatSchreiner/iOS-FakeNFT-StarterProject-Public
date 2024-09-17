import Foundation

struct NFTCollection: Decodable {
    let name: String
    let cover: String
    let nfts: [String]
    let id: String
}
