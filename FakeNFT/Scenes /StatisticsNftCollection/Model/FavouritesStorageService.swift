import Foundation

final class FavoritesStorage {
    //MARK: - private properties
    private let favoritesKey = "likedNFTs"
    static let shared = FavoritesStorage()
    
    //MARK: - initialization
    private init() {}
    
    //MARK: - public methods
    func isNftLiked(nftId: String) -> Bool {
        let likedNFTs = getFavoriteNfts()
        return likedNFTs.contains(nftId)
    }
    
    func toggleFavoriteNft(nftId: String) {
        var likedNFTs = getFavoriteNfts()
        if let index = likedNFTs.firstIndex(of: nftId) {
            likedNFTs.remove(at: index)
        } else {
            likedNFTs.append(nftId)
        }
        
        UserDefaults.standard.set(likedNFTs, forKey: favoritesKey)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - private methods
    func getFavoriteNfts() -> [String] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
    }
    
}
