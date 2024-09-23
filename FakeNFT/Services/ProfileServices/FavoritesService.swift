//
//  LikesService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 22.09.2024.
//

import Foundation

final class FavoritesService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func updateFavoriteNft(profileId: String, nftId: String, isLiked: Bool, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        let action = isLiked ? "добавление" : "удаление"
        let request = FavoriteStatusRequest(nftId: nftId, profileId: profileId)
        print("[FavoritesService:updateFavoriteNft]: Отправка запроса на \(action) NFT. NFT ID: \(nftId), Profile ID: \(profileId)")
        
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                print("[FavoritesService:updateFavoriteNft]: NFT успешно \(isLiked ? "добавлен" : "удален") из избранного.")
                completion(.success(()))
            case .failure(let error):
                print("[FavoritesService:updateFavoriteNft]: Ошибка при \(action) NFT из избранного. Ошибка: \(error.localizedDescription)")
                completion(.failure(error as? NetworkClientError ?? .urlSessionError))
            }
        }
    }
    
    func updateLikesProfile(
        likes: [String],
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        let dto = UpdateLikesDto(likes: likes)
        let request = UpdateLikesRequest(dto: dto)
        
        print("[UpdateProfileService:updateProfile]: Запрос на сервер для обновление профиля: \(dto)")
        
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let response):
                print("[UpdateProfileService:updateProfile]: Профиль обновлен на сервере успешно. Ответ: \(response)")
                completion(.success(response))
            case .failure(let error):
                print("[UpdateProfileService:updateProfile]: Ошибка при обновлении профиля на сервере: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
