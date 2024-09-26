import Foundation

struct StatisticsOrderRequest: NetworkRequest {    
    init() {}
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/orders/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }

    var httpMethod: HttpMethod {
        return .get
    }

    var dto: Dto? {
        return nil
    }
}
