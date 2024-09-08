//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/profile/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var dto: Dto? {
        return nil
    }
}
