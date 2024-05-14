//
//  Transaction.swift
//  ios-money-management
//
//  Created by AnNguyen on 27/04/2024.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
class Transaction  {
    private let id:String
    private var description:String
    private var balance: Int
    private let category: Category
    private let create_at:Date
    var getID:String{
        get{
            return id
            
        }
    }
    var getDescription:String{
        get{
            return description
        }
    }
    var getBalance:Int{
        get{
            return balance
        }
    }
    var getCategory:Category{
        get{
            return category
        }
    }
    var getCreateAt:Date{
        get{
            return create_at
        }
    }
    
    init(id: String, description: String, balance: Int, category: Category, create_at: Date) {
        self.id = id
        self.description = description
        self.balance = balance
        self.category = category
        self.create_at = create_at
    }
    public static func getAllMyTransactions(WalletID:String) async -> [Transaction]?{
        let db = Firestore.firestore()
        let walletRef = db.collection("Transactions").document(WalletID).collection("Transaction")
        var myTransactions = [Transaction]()
        
        do {
            let snapshot = try await walletRef.getDocuments() // Lấy tất cả documents
            for transaction in snapshot.documents{
//                print("Transaction ID: \(transaction.documentID)")
                print(transaction["Description"] as! String)
                await myTransactions.append(
                    Transaction(
                        id: transaction["ID"] as! String,
                        description:  transaction["Description"] as! String,
                        balance: transaction["Balance"] as! Int,
                        category: Category.getCategory(Category_ID: transaction["Category_ID"] as! String)!,
                        create_at: Date()
                    )
                )
                
            }
            
            return myTransactions
        } catch {
            print("Lỗi truy vấn - getMyWallets: \(error)")
            return nil
        }
    }
}
