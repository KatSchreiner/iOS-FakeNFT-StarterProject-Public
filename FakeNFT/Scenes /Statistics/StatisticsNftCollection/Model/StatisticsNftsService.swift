import Foundation

final class StatisticsNftsService {
    
    // MARK: - Public Properties
    static let shared = StatisticsNftsService()
    
    // MARK: - Private Properties
    private let defaultNetwork = DefaultNetworkClient()
    
    // MARK: Initialization
    private init() {}
    
    // MARK: - Public methods
    func fetchNfts(nftIds: [String], completion: @escaping (Result<[NftById], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var nftCollection = [NftById]()
        
        for nft in nftIds {
            dispatchGroup.enter()
            let request = StatisticsNftById(nftId: nft)
            defaultNetwork.send(request: request, type: NftById.self) { result in
                switch result {
                case .success(let nft):
                    nftCollection.append(nft)
                case .failure(let error):
                    print("Error: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(nftCollection))
        }
    }
    
    func fetchCart(completion: @escaping (Result<Order, Error>) -> Void) {
        let request = StatisticsOrderRequest()
        defaultNetwork.send(request: request, type: Order.self ) { result in
            completion(result)
        }
    }
    
    func fetchProfile( completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = StatisticsProfileRequest()
        defaultNetwork.send(request: request, type: UserProfile.self) { result in
            completion(result)
        }
    }
    
    func updateOrder(with nftId: String, in cart: [String], completion: @escaping (Result<Order, Error>) -> Void) {
        var cart = cart
        if cart.contains(nftId) {
            cart = cart.filter { $0 != nftId }
        } else {
            cart.append(nftId)
        }
        let request = StatisticsOrderUpdate(cart: cart)
        defaultNetwork.send(request: request, type: Order.self, completionQueue: .main) { result in
            completion(result)
        }
    }
    
    func updateLike(with nft: String, in likes: [String], completion: @escaping (Result<UserProfile, Error>) -> Void) {
        var likes = likes
        if likes.contains(nft) {
            likes = likes.filter { $0 != nft }
        } else {
            likes.append(nft)
        }
        let request = StatisticsLikeUpdate(likes: likes)
        defaultNetwork.send(request: request, type: UserProfile.self, completionQueue: .main) { result in
            completion(result)
        }
    }
}
