//
//  String + Extension.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 27.09.2024.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }
}
