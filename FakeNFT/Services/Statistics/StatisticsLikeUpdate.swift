import Foundation

struct StatisticsLikeUpdate: NetworkRequest {
    var likes: [String]
    init(likes: [String]) {
        self.likes = likes
    }
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/profile/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        if likes.isEmpty { return nil }
        return LikesDto(likes: likes)
    }
}

struct LikesDto: Dto {
    let likes: [String]
    
    func asDictionary() -> [String: String] {
        let likesString = likes.joined(separator: "&likes=")
        return ["likes": likesString]
    }
}
