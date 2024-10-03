import Foundation

struct StatisticsProfileRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
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
