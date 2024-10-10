//
//  UpdateLikesRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 23.09.2024.
//

import Foundation

struct UpdateLikesRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    private let profileId: String
    
    init(profileId: String, dto: UpdateLikesDto) {
        self.profileId = profileId
        self.dto = dto
    }
}

struct UpdateLikesDto: Dto {
    let likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case likes
    }
    
    func asDictionary() -> [String : String] {
        if !likes.isEmpty {
            return [CodingKeys.likes.rawValue: likes.joined(separator: ",")]
        } else {
            return [CodingKeys.likes.rawValue: "null"]
        }
    }
}
