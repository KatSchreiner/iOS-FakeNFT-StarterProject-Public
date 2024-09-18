import Foundation

// MARK: CatalogueService

class CatalogueService {
    private let pathCollections = "/api/v1/collections"
    private let pathNft = "/api/v1/nft/"
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections(completion: @escaping (Result<[NFTCollections], Error>) -> Void) {
        guard let url = URL(string: RequestConstants.baseURL + pathCollections) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let request = DefaultNetworkRequest(endpoint: url, httpMethod: .get)
        
        networkClient.send(request: request, type: [NFTCollections].self) { result in
            completion(result)
        }
    }
    
    func fetchNFT(id: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        guard let url = URL(string: RequestConstants.baseURL + pathNft + id) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let request = DefaultNetworkRequest(endpoint: url, httpMethod: .get)
        
        networkClient.send(request: request, type: NFT.self) { result in
            completion(result)
        }
    }
}
