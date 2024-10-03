import Foundation

struct StatisticsUserPageRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/users/\(self.userId)"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }

    var httpMethod: HttpMethod {
        return .get
    }

    var dto: Dto? {
        return nil
    }
}
