//
//  Nft.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import Foundation

struct NftList: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
