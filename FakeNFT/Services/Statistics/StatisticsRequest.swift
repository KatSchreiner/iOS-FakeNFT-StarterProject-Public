import Foundation

struct StatisticsRequest: NetworkRequest {
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/users"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }

    var httpMethod: HttpMethod {
        return .get
    }

    var dto: Dto? {
        return nil
    }
}
