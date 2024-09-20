//
//  Profile.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 08.09.2024.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    var nfts: [String]
    let likes: [String]
    let id: String
}
