final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileService: ProfileService
    private let updateProfile: UpdateProfileService
    private let nftList: NftListService
    private let favoritesService: FavoritesService
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileService: ProfileService,
        updateProfile: UpdateProfileService,
        nftList: NftListService,
        favoritesService: FavoritesService
        
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileService = profileService
        self.updateProfile = updateProfile
        self.nftList = nftList
        self.favoritesService = favoritesService
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        ) as NftService
    }
    
    var profileServiceInstance: ProfileService {
        return profileService
    }
    
    var updateProfileInstanse: UpdateProfileService {
        return updateProfile
    }
    
    var nftListInstanse: NftListService {
        return nftList
    }
    
    var favoritesServiceInstanse: FavoritesService {
        return favoritesService
    }
}
