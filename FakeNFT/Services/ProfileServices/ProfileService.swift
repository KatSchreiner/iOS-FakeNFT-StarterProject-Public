//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 08.09.2024.
//

import Foundation

final class ProfileService {    
    private let networkClient: NetworkClient
    private(set) var profile: Profile?
    private var avatar: String?
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
        print("[ProfileService:fetchProfile]: Инициализация сетевого клиента NetworkClient")
    }
    
    func setAvatar(_ avatar: String?) {
        self.avatar = avatar
    }
    
    func getAvatar() -> String? {
        return avatar
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, NetworkClientError>) -> Void) {
        print("[ProfileService:fetchProfile]: Запрос профиля пользователя начат...")
        let request = ProfileRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                print("[ProfileService:fetchProfile]: Запрос профиля успешен. Получены данные: \(data)")
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    self.profile = profile
                    completion(.success(profile))
                    print("[ProfileService:fetchProfile]: Профиль успешно декодирован: \(profile)")
                    
                    let avatarURL = "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG"
                    self.setAvatar(avatarURL)
                    print("[ProfileService:fetchProfile]: Получено URL аватара: \(avatarURL)")
                    
                } catch {
                    completion(.failure(.parsingError))
                    print("[ProfileService:fetchProfile]: Ошибка декодирования: \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error as? NetworkClientError ?? NetworkClientError.urlSessionError))
                print("[ProfileService:fetchProfile]: Ошибка при получении профиля: \(error)")
            }
        }
    }
}
