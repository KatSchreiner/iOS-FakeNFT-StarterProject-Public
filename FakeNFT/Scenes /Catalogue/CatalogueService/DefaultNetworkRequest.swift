import Foundation

struct DefaultNetworkRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto? 

    init(endpoint: URL?, httpMethod: HttpMethod, dto: Dto? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
    }
}
