//
//  Wallet.swift
//  ios-money-management
//
//  Created by AnNguyen on 09/05/2024.
//

import Foundation
import UIKit
class Wallet {
    var walletName: String
    var walletImg: UIImage?
    var walletBalance: Int
    init(walletName: String, walletImg: UIImage?, walletBalance: Int) {
        self.walletName = walletName
        self.walletImg = walletImg
        self.walletBalance = walletBalance
    }
}
