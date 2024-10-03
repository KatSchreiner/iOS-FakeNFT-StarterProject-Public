import Foundation

final class GetNFTByIdRequest: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var dto: (any Dto)?
    
    var httpMethod: HttpMethod

    private let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    
    init(id: String, httpMethod: HttpMethod) {
        self.id = id
        self.httpMethod = httpMethod
    }
}
