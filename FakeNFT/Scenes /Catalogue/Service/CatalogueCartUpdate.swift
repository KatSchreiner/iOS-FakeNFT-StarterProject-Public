import Foundation

struct CatalogueCartUpdate: NetworkRequest {
    var httpBody: Data?
    
    var contentType: String?
    
    var cart: [String]
    init(cart: [String]) {
        self.cart = cart
    }
    
    var endpoint: URL? {
        let baseURL = RequestConstants.baseURL
        let profileEndpoint = "/api/v1/orders/1"
        return URL(string: "\(baseURL)\(profileEndpoint)")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        if cart.isEmpty { return nil }
        return OrderDto(cart: cart)
    }
}

struct CatalogueDto: Dto {
    let cart: [String]
    
    func asDictionary() -> [String: String] {
        let nftsString = cart.joined(separator: "&nfts=")
        return ["nfts": nftsString]
    }
}
