final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileService: ProfileService
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileService: ProfileService
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileService = profileService
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileServiceInstance: ProfileService {
        return profileService
    }
}
