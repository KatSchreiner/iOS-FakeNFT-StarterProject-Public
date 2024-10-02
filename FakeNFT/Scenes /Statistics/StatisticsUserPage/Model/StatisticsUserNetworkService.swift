import Foundation

final class StatisticsUserNetworkService {
        
    // MARK: - Public Properties
    static let shared = StatisticsUserNetworkService()
    
    // MARK: - Private Properties
    private let defaultNetwork = DefaultNetworkClient()
    
    // MARK: Initialization
    private init() {}
    
    // MARK: - Public methods
    func fetchUser(userId: String, completion: @escaping (Result<Statistics, Error>) -> Void) {
        let request = StatisticsUserPageRequest(userId: userId)
        defaultNetwork.send(request: request, type: Statistics.self, onResponse: completion)
    }
}
