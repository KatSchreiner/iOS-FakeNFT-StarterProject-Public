//
//  UpdateLikesRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 23.09.2024.
//

import Foundation

struct UpdateLikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    
    init(dto: UpdateLikesDto) {
        self.dto = dto
    }
}

struct UpdateLikesDto: Dto {
    let likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case likes
    }
    
    func asDictionary() -> [String : String] {
        [CodingKeys.likes.rawValue: likes.joined(separator: ",")]
    }
}
