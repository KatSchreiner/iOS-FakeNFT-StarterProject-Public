//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 16.09.2024.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?

    init(dto: UpdateProfileDto) {
        self.dto = dto
    }
}

struct UpdateProfileDto: Dto {
    let avatar: String
    let name: String
    let description: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case avatar
        case name
        case description = "description"
        case website = "website"
    }

    func asDictionary() -> [String : String] {
        [
            CodingKeys.avatar.rawValue: avatar,
            CodingKeys.name.rawValue: name,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website
        ]
    }
}
