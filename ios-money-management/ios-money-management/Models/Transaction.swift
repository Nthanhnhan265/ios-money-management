//
//  Transaction.swift
//  ios-money-management
//
//  Created by AnNguyen on 27/04/2024.
//

import Foundation
import UIKit
class Transaction  {
    private let ID:String
    private var Description:String
    private var Balance: Int
    private let Category_ID: String
    private let CreateAt:Date
    
    init(ID: String, Description: String, Balance: Int, Category_ID: String, CreateAt: Date) {
        self.ID = ID
        self.Description = Description
        self.Balance = Balance
        self.Category_ID = Category_ID
        self.CreateAt = CreateAt
    }
    public static func WriteTransaction(UID:String, Wallet_ID:String,transaction:Transaction ){
        
    }
}
