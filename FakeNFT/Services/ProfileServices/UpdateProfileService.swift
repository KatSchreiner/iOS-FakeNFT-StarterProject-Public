//
//  UpdateProfileService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 16.09.2024.
//

import Foundation

final class UpdateProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func updateProfile(
        avatar: String,
        name: String,
        description: String,
        website: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        let dto = UpdateProfileDto(avatar: avatar, name: name, description: description, website: website)
        let request = UpdateProfileRequest(dto: dto)
        
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
