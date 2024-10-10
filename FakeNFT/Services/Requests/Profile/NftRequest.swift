//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import Foundation

struct NftRequest: NetworkRequest {
    var httpBody: Data?
    var contentType: String?
    let id: String
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        return URL(string: "\(baseURL)/api/v1/nft/\(id)")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var dto: Dto? {
        return nil
    }
}
