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
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
        print("[ProfileService:fetchProfile]: Инициализация сетевого клиента NetworkClient")
    }

    func fetchProfile(completion: @escaping (Result<Profile, NetworkClientError>) -> Void) {
        print("[ProfileService:fetchProfile]: Запрос профиля пользователя начат...")
        let request = ProfileRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                print("[ProfileService:fetchProfile]: Запрос профиля успешен.")
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    self.profile = profile
                    completion(.success(profile))
                    print("[ProfileService:fetchProfile]: Профиль успешно декодирован: \(profile)")
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
