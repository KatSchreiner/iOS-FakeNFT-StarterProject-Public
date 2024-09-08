//
//  ProfileImageService.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 08.09.2024.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let networkClient: NetworkClient
    
    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func downloadAvatar(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = ImageDownloadRequest(url: url)
        
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
