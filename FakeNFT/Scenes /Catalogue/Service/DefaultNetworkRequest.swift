import Foundation

struct DefaultNetworkRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    var httpBody: Data?
    var contentType: String?

    init(endpoint: URL?, httpMethod: HttpMethod, dto: Dto? = nil, httpBody: Data? = nil, contentType: String? = nil) {
            self.endpoint = endpoint
            self.httpMethod = httpMethod
            self.dto = dto
            self.httpBody = httpBody
            self.contentType = contentType
        }
}

struct UpdateCartRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto? = nil 
    var httpBody: Data?
    var contentType: String?

    init(endpoint: URL?, httpMethod: HttpMethod, body: Data?, contentType: String?) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.httpBody = body
        self.contentType = contentType
    }
}
