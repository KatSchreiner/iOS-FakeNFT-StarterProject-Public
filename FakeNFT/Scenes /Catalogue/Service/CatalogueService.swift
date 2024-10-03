import Foundation

// MARK: - CatalogueServiceProtocol
protocol CatalogueServiceProtocol: AnyObject {
    func fetchCollections(completion: @escaping (Result<[CatalogueNFTCollection], Error>) -> Void)
    func fetchAllNFTs(for nfts: [String], completion: @escaping (Result<[NFT], Error>) -> Void)
    func fetchNFT(id: String, completion: @escaping (Result<NFT, Error>) -> Void)
    func fetchCart(completion: @escaping (Result<CatalogueCart, Error>) -> Void)
    func updateCart(with nft: String, in cart: [String], completion: @escaping (Result<CatalogueCart, Error>) -> Void)
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
    func updateLike(with nft: String, in likes: [String], completion: @escaping (Result<UserProfile, Error>) -> Void)
}

// MARK: CatalogueService

final class CatalogueService: CatalogueServiceProtocol {
    private let pathCollections = "/api/v1/collections"
    private let pathNft = "/api/v1/nft/"
    private let pathOrder = "/api/v1/orders/1"
    private let pathProfile = "/api/v1/profile/1"
    private let networkClient: NetworkClient
    private var task: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections(completion: @escaping (Result<[CatalogueNFTCollection], Error>) -> Void) {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.task != nil { return }
            task?.cancel()
            
            
            guard let url = URL(string: RequestConstants.baseURL + pathCollections) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }
            
            let request = DefaultNetworkRequest(endpoint: url, httpMethod: .get)
            
            self.task = networkClient.send(request: request, type: [CatalogueNFTCollection].self) { result in
                self.task = nil
                UIBlockingProgressHUD.dismiss()
                completion(result)
            }
        }
    }
    
    func fetchAllNFTs(for nfts: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        UIBlockingProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        let nftsListQueue = DispatchQueue(label: "nftsListQueue", qos: .userInitiated, attributes: .concurrent)
        var nftsList: [NFT] = []
        
        for id in nfts {
            dispatchGroup.enter()
            fetchNFT(id: id) { result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let nft):
                    nftsListQueue.async(flags: .barrier) {
                        nftsList.append(nft)
                    }
                case .failure(let error):
                    print("⚠️ Ошибка при загрузке NFT с id \(id): \(error)")
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            let nftsList = nftsList.sorted { $0.id < $1.id }
            completion(.success(nftsList))
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
    
    func fetchCart(completion: @escaping (Result<CatalogueCart, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.task != nil { return }
            task?.cancel()
            
            guard let url = URL(string: RequestConstants.baseURL + pathOrder) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }
            
            let request = DefaultNetworkRequest(endpoint: url, httpMethod: .get)
            self.task = networkClient.send(request: request, type: CatalogueCart.self) { result in
                self.task = nil
                completion(result)
            }
        }
    }
    
    func updateCart(with nft: String, in cart: [String], completion: @escaping (Result<CatalogueCart, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.task != nil { return }
            task?.cancel()
            var cart = cart
            if cart.contains(nft) {
                cart = cart.filter { $0 != nft }
            } else {
                cart.append(nft)
            }
            
            let request = CatalogueCartUpdate(cart: cart)
            
            self.task = networkClient.send(request: request, type: CatalogueCart.self) { result in
                self.task = nil
                completion(result)
            }
        }
    }
    
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            //guard let self = self else { return }
            //if self.task != nil { return }
            //task?.cancel()
            
            guard let url = URL(string: RequestConstants.baseURL + pathProfile) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }
            
            let request = DefaultNetworkRequest(endpoint: url, httpMethod: .get)
            
            /*self.task = */networkClient.send(request: request, type: UserProfile.self) { result in
                //self.task = nil
                completion(result)
            }
        //}
    }
    
    func updateLike(with nft: String, in likes: [String], completion: @escaping (Result<UserProfile, Error>) -> Void) {
        //DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            //guard let self = self else { return }
            //if self.task != nil { return }
            //task?.cancel()
            
            var likes = likes
            if likes.contains(nft) {
                likes = likes.filter { $0 != nft }
            } else {
                likes.append(nft)
            }
            
            let request = CatalogueLikeUpdate(likes: likes)
            
            /*self.task = */networkClient.send(request: request, type: UserProfile.self) { result in
                //self.task = nil
                completion(result)
            }
        }
    //}
}





