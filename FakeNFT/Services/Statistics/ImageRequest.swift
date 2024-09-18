import UIKit

struct ImageRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?

    init(url: URL) {
        self.endpoint = url
        self.httpMethod = .get
        self.dto = nil
    }
}

final class StatisticsImageService {
    static let shared = StatisticsImageService()
    private let networkClient: NetworkClient

    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func downloadPhoto(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = ImageRequest(url: url)

        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

