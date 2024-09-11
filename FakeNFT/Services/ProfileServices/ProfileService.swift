//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 08.09.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let networkClient: NetworkClient
    private(set) var profile: Profile?
    private(set) var avatar: String?
    
    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, NetworkClientError>) -> Void) {
        let request = ProfileRequest()
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    self.profile = profile
                    completion(.success(profile))
                    
                    let avatarURL = "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG"
                    self.avatar = avatarURL
                    print("URL аватара: \(avatarURL)")
                    
                } catch {
                    completion(.failure(.parsingError))
                    print("Ошибка декодирования: \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error as! NetworkClientError))
                print("Ошибка при получении профиля: \(error)")
            }
        }
    }
}
