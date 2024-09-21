import Foundation

struct CollectionMockData {
    static let collections: [NFTCollections] = [
        NFTCollections(
            name: "CryptoKitties",
            cover: "https://nft-arty.com/wp-content/uploads/2022/05/image7-6.png",
            nfts: ["Kitty1", "Kitty2", "Kitty3"],
            id: "1"
        ),
        NFTCollections(
            name: "Bored Ape Yacht Club",
            cover: "https://nft-arty.com/wp-content/uploads/2022/05/image5-6.png",
            nfts: ["Ape1", "Ape2"],
            id: "2"
        ),
        NFTCollections(
            name: "PunkArt",
            cover: "https://nft-arty.com/wp-content/uploads/2022/05/image4-10.png",
            nfts: ["Punk1", "Punk2", "Punk3", "Punk4"],
            id: "3"
        ),
        NFTCollections(
            name: "Unreleased",
            cover: "https://www.film.ru/sites/default/files/filefield_paths/8_17.jpeg",
            nfts: ["Release1", "Release2", "Release3", "Release4, Release5"],
            id: "4"
        ),
        NFTCollections(
            name: "Bank",
            cover: "https://nft-arty.com/wp-content/uploads/2022/05/image6-6.png",
            nfts: ["Bank1", "Bank2", "Bank3", "Bank4, Bank5"],
            id: "5"
        ),
        NFTCollections(
            name: "Doggy",
            cover: "https://nft-arty.com/wp-content/uploads/2022/05/image2-8.png",
            nfts: ["Doggy1", "Doggy2", "Doggy3", "Doggy4, Doggy5, Doggy6"],
            id: "6"
        )
    ]
}
