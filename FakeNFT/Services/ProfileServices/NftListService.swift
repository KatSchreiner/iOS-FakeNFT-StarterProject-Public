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
    
    func fetchNfts(completion: @escaping (Result<[NFT], NetworkClientError>) -> Void) {
        print("[NftListService: fetchNfts]: Запрос на получение NFT начат...")
        let request = NftRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let nfts = try JSONDecoder().decode([NFT].self, from: data)
                    print("✅ [NftListService: fetchNfts]: Запрос NFT завершен успешно. Данные NFT успешно декодированы, количество: \(nfts.count)")
                    completion(.success(nfts))
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
