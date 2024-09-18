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

        func fetchNfts(completion: @escaping (Result<[NftList], NetworkClientError>) -> Void) {
            let request = NftListRequest()
            print("[NftListService:fetchNfts]: Запрос на получение NFT начат...")

            networkClient.send(request: request) { result in
                switch result {
                case .success(let data):
                    print("[NftListService:fetchNfts]: Запрос выполнен успешно. Получены данные: \(data)")
                    do {
                        let nfts = try JSONDecoder().decode([NftList].self, from: data)
                        print("[NftListService:fetchNfts]: Данные успешно декодированы в модель NftList: \(nfts)")
                        completion(.success(nfts))
                    } catch {
                        print("[NftListService:fetchNfts]: Ошибка декодирования: \(error.localizedDescription)")
                        completion(.failure(.parsingError))
                    }
                case .failure(let error):
                    print("[NftListService:fetchNfts]: Ошибка при запросе: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkClientError ?? NetworkClientError.urlSessionError))
                }
            }
        }
}
