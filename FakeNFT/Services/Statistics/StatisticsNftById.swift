import Foundation

struct StatisticsNftById: NetworkRequest {
    var nftId: String
    
    init(nftId: String) {
        self.nftId = nftId
    }
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/nft/\(self.nftId)"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }

    var httpMethod: HttpMethod {
        return .get
    }

    var dto: Dto? {
        return nil
    }
}
