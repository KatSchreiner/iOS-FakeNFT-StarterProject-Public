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
    
    func checkIfNftInOrder(nftId: String, completion: @escaping (Bool) -> Void) {
        let fetchOrderRequest = StatisticsOrderRequest()
        defaultNetwork.send(request: fetchOrderRequest, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(order.nfts.contains(nftId))
            case .failure(let error):
                print("Failed to fetch order: \(error)")
                completion(false)
            }
        }
    }
    
    func addToOrder(nftId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let updateOrderRequest = StatisticsOrderUpdate(nftId: nftId)
        defaultNetwork.send(request: updateOrderRequest, completionQueue: .main) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
