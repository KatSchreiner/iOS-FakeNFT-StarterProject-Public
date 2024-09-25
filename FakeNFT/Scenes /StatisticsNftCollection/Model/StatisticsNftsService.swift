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
}
