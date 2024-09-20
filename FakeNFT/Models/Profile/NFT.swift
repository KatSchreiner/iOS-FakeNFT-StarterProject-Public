//
//  Nft.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import Foundation

struct NFT: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
