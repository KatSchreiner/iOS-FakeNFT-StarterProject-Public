//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import Foundation

struct NftRequest: NetworkRequest {
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        return URL(string: "\(baseURL)/api/v1/nft")
    }

    var httpMethod: HttpMethod {
        return .get
    }

    var dto: Dto? {
        return nil
    }
}
