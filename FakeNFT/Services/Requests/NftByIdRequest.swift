import Foundation

struct NFTRequest: NetworkRequest {
    var httpBody: Data?
    var contentType: String?
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}
