//
//  Untitled.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 22.09.2024.
//

import Foundation

struct FavoriteStatusRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/profile/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        return LikeDto(nftId: nftId, profileId: profileId)
    }
    
    private let nftId: String
    private let profileId: String
    
    init(nftId: String, profileId: String) {
        self.nftId = nftId
        self.profileId = profileId
    }
}

struct LikeDto: Dto {
    let nftId: String
    let profileId: String
    
    func asDictionary() -> [String : String] {
        return [
            "nftId": nftId,
            "profileId": profileId
        ]
    }
}
