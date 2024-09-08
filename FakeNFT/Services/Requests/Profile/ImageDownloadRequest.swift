//
//  ImageDownloadRequest.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 09.09.2024.
//

import Foundation

struct ImageDownloadRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    
    init(url: URL) {
        self.endpoint = url
        self.httpMethod = .get
        self.dto = nil
    }
}
