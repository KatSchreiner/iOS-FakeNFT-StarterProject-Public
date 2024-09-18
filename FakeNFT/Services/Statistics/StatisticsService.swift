import UIKit

protocol StatisticsServiceProtocol {
    func fetchStatistics(completion: @escaping (Result<[Statistics], NetworkClientError>) -> Void)
}


final class StatisticsService: StatisticsServiceProtocol{
    static let shared = StatisticsService()

    private let networkClient: NetworkClient
    private(set) var users: [Statistics]?

    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchStatistics(completion: @escaping (Result<[Statistics], NetworkClientError>) -> Void) {
        let request = StatisticsRequest()
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let users = try JSONDecoder().decode([Statistics].self, from: data)
                    self.users = users
                    completion(.success(users))
                } catch {
                    completion(.failure(.parsingError))
                    print("Error decoding statistics: \(error.localizedDescription)")
                }
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(.urlSessionError))
                }
                print("Error fetching statistics: \(error.localizedDescription)")
            }
        }
    }
}
