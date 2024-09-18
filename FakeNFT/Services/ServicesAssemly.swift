final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileService: ProfileService
    private let updateProfile: UpdateProfileService
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileService: ProfileService,
        updateProfile: UpdateProfileService
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileService = profileService
        self.updateProfile = updateProfile
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
    
    var updateProfileInstanse: UpdateProfileService {
        return updateProfile
    }
}
