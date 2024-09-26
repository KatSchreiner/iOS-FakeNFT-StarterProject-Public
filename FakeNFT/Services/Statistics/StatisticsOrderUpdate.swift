import Foundation

struct OrderDto: Dto {
    let nfts: String

    func asDictionary() -> [String: String] {
        return ["nfts": nfts]
    }
}

struct StatisticsOrderUpdate: NetworkRequest {
    var nftId: String
    
    init(nftId: String) {
        self.nftId = nftId
    }
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/orders/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        return OrderDto(nfts: self.nftId)
    }
}
