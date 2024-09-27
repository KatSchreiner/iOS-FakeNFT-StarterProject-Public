import Foundation

struct Order: Codable {
    var nfts: [String]
    let id: String
    
    mutating func addNft(_ nftId: String) {
        if !nfts.contains(nftId) {
            nfts.append(nftId)
            print("Added NFT \(nftId) to the order.")
        } else {
            print("NFT \(nftId) is already in the order.")
        }
    }
    
    mutating func removeNft(_ nftId: String) {
        if let index = nfts.firstIndex(of: nftId) {
            nfts.remove(at: index)
            print("Removed NFT \(nftId) from the order.")
        } else {
            print("NFT \(nftId) is not found in the order.")
        }
    }
}
