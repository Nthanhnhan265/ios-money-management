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
                await myTransactions.append(
                    Transaction(
                        id: transaction["ID"] as! String,
                        description:  transaction["Description"] as! String,
                        balance: transaction["Balance"] as! Int,
                        category: Category.getCategory(Category_ID: transaction["Category_ID"] as! String)!,
                        create_at: (transaction["CreateAt"] as? Timestamp)?.dateValue() ?? Date()
                    )
                )
            }
            
            return myTransactions
        } catch {
            print("Lỗi truy vấn - getMyWallets: \(error)")
            return nil
        }
    }
    /// Hàm chuyển đồ từ Date sang String
    func DateToString(str_date date:Date) -> String{
        // Lấy ra 1 biến Date ở thời gian hiện tại
        let currentDateAndTime = date
        // Tạo ra 1 biến format
        let dateFormatter = DateFormatter()
        
        // Ngày: 5/9/24
        dateFormatter.dateStyle = .short
        
        // Giờ none
        dateFormatter.timeStyle = .none
        
        // Địa điểm
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        //09/05/2024
        // print(dateFormatter.string(from: currentDateAndTime))
        // Date -> String
        // print(type(of: dateFormatter.string(from: currentDateAndTime)))
        
        
        return dateFormatter.string(from: currentDateAndTime)
    }
    /// Hàm Chuyển đổi từ String sang Date
    func StringToDate(_ str_date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        if let rs = dateFormatter.date(from: str_date){
            
            
            return rs
        }
        else
        {
            print("<<<<<String to Date KHÔNG THÀNH CÔNG - TransactionViewController>>>>>")
            return Date.now
        }
    }
    public static func addTransaction(wallet_id:String, balance:Int, category_id:String, des:String ){
        let db = Firestore.firestore()
        
        // Tạo một DocumentReference để lấy ID sau khi document được tạo
        let transactionRef = db.collection("Transactions").document(wallet_id).collection("Transaction").document()
        
        let transactionData: [String: Any] = [
            "Balance": balance,
            "Category_ID": category_id,
            "Description": des,
            "CreateAt": Date()
        ]
        // Sử dụng transactionRef để thêm document
        transactionRef.setData(transactionData) { error in
            if let error = error {
                print("Error adding transaction: \(error)")
            } else {
                // Cập nhật lại document với trường ID
                transactionRef.updateData(["ID": transactionRef.documentID])
                print("Transaction added successfully!")
            }
        }
        
    }
  

}
