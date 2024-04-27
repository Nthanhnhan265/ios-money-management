//
//  Transaction.swift
//  ios-money-management
//
//  Created by AnNguyen on 27/04/2024.
//

import Foundation
import UIKit
class Transaction  {
// MARK: Props
    var transactionName: String
    var transactionImage: UIImage?
    var transactionBalance: Int
    var transactionTime: String
    var transactionDes: String
//    MARK: Initialization
    init?(name: String, img: UIImage?, balance: Int, time: String, des: String) {
        self.transactionName = name
        self.transactionImage = img
        self.transactionBalance = balance
        self.transactionTime = time
        self.transactionDes = des
    }
}
