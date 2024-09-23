//
//  BackButton.swift
//  FakeNFT
//
//  Created by Екатерина Шрайнер on 18.09.2024.
//

import UIKit

class BackButton: UIBarButtonItem {
    convenience init(target: Any?, action: Selector) {
        self.init(title: "", style: .plain, target: target, action: action)
        tintColor = .nBlack
        image = UIImage(systemName: "chevron.left")
    }
}
