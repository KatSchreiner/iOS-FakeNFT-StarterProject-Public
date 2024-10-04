//
//  NftListService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import Foundation

final class NftListService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchNfts(id: String, completion: @escaping (Result<NFT, NetworkClientError>) -> Void) {
        let request = NftRequest(id: id)
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let nft = try JSONDecoder().decode(NFT.self, from: data)
                    completion(.success(nft))
                } catch {
                    print("❌ [NftListService: fetchNfts]: Ошибка декодирования данных: \(error.localizedDescription)")
                    completion(.failure(.parsingError))
                }
            case .failure(let error):
                print("❌ [NftListService: fetchNfts]: Ошибка при получении NFT: \(error)")
                completion(.failure(error as? NetworkClientError ?? NetworkClientError.urlSessionError))
            }
        }
    }
}
