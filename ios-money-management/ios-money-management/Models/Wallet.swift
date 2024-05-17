//
//  Wallet.swift
//  ios-money-management
//
//  Created by AnNguyen on 09/05/2024.
//

import Foundation
import FirebaseFirestore
import UIKit

import FirebaseCore
import FirebaseFirestore
class Wallet {
    private let id:String
    private var name: String
    private var balance: Int
    private  var image: UIImage?
    private var transactions = [Transaction]()
    
    
    init(ID: String, Name: String, Balance: Int, Image: UIImage? = nil, Transaction: [Transaction]) {
        self.id = ID
        self.name = Name
        self.balance = Balance
        self.image = Image
        self.transactions = Transaction
    }
    var getID:String{
        get{
            return id
            
        }
    }
    var getImageName:String{
        get{
            return image?.imageAsset?.value(forKey: "assetName") as! String
            
        }
    }
    var getName:String{
        get{
            return name
        }
    }
    var Balance:Int{
        get{
            return balance
        }
        set{
            balance = newValue
        }
    }
    var getImage:UIImage?{
        get{
            return image
        }
    }
    
    
//  MARK: GET SET Transactions cho Wallet
    func getTransactions() -> [Transaction] {
            return transactions
        }
    func addTransaction(transaction: Transaction) {
            transactions.append(transaction)
        }
    public func ToString(){
        print("Wallet: \(id) - \(name) - \(balance)")
    }
    public static func getMyWallets(UID:String) async -> [Wallet]?{
        let db = Firestore.firestore()
        let walletRef = db.collection("Wallets").document(UID).collection("Wallet")
        var myWallets = [Wallet]()
        
        do {
            let snapshot = try await walletRef.getDocuments() // Lấy tất cả documents
            
            for i in snapshot.documents{
                //                print("ID VÍ: \(i.documentID)")
                
                await myWallets.append(
                    Wallet(
                        ID: i["ID"] as! String,
                        Name: i["Name"] as! String,
                        Balance:i["Balance"] as! Int,
                        Image: UIImage(named: i["Image"] as! String),
                        Transaction: Transaction.getAllMyTransactions(walletID: i.documentID)!
                    )
                )
                
            }
            return myWallets
        } catch {
            print("Lỗi truy vấn - getMyWallets: \(error)")
            return nil
        }
    }
    
    
    
    //tao vi moi
    static func createNewWallet(_ UID: String, _ walletDictionary:[String:Any])->Void {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletRef = userRef.collection("Wallets")
        if walletDictionary.count != 0 {
            let newWallet = walletRef.addDocument(data: walletDictionary) { error in
                if let error = error {
                    print("Error adding wallet: \(error)")
                    return
                }
                
                print("Wallet created successfully!")
            }
            let insertedID = newWallet.documentID;
            //goi ham updateAWallet va cap nhat id cho vi
            updateAWallet(UID, insertedID, ["ID":insertedID])
        }
    }
    //cap nhat vi
    static func updateAWallet(_ UID: String, _ walletID:String, _ walletDictionary:[String:Any])->Void {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletDoc = userRef.collection("Wallets").document(walletID)
        if walletDictionary.count != 0 {
            walletDoc.updateData(walletDictionary) { error in
                if let error = error {
                    print("Error adding wallet: \(error)")
                    return
                }
                print("Wallet updated successfully!")
            }
        }
    }
    //xoa vi
    static func deleteAWallet(_ UID: String, _ walletID:String) {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletDoc = userRef.collection("Wallets").document(walletID)
        walletDoc.getDocument { document, error in
            if let error = error {
                print("Error deleting wallet \(error)")
                return
            }
            if let document = document, document.exists {
                walletDoc.delete()
                print("Wallet deleted successfully")
            }
        }
    }
    // MARK: Tâm An - Cập nhật ví
    /// Cập nhật lại thông tin wallet của UID
    static func set_updateWallet(UID:String, wallet: Wallet){
        let db = Firestore.firestore()
        let walletRef = db.collection("Wallets").document(UID)
        
        let walletDoc = walletRef.collection("Wallet").document(wallet.getID)
        
        // Dữ liệu mới của ví
            let walletData: [String: Any] = [
                "Name": wallet.getName,
                "Balance": wallet.Balance,
                "ID": wallet.getID,
            ]

            // Cập nhật dữ liệu ví trên Firestore
            walletDoc.updateData(walletData) { error in
                if let error = error {
                    print("Error updating wallet: \(error)")
                } else {
                    print("Wallet updated successfully!")
                }
            }

    }
    
    // lay tat ca du lieu trong vi
    static func getAllWallets(UID: String, completion: @escaping ([Wallet], _ totalBalnce:Int)->Void ) {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletRef = userRef.collection("Wallets")
        var arrWalletObjects = [Wallet]()
        
        walletRef.getDocuments {
            query, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([],0)
                return
            }
            var total:Int = 0
            if let documents = query?.documents, !documents.isEmpty {
                for wallet in documents {
                    let data = wallet.data()
                    var walletName:String?
                    var walletBalance:Int?
                    var walletImage:String?
                    var walletId:String?
                    
                    if let name = data["Name"] as? String {
                        walletName = name
                    }
                    if let balance = data["Balance"] as? Int {
                        walletBalance = balance
                        total += balance
                    }
                    if let image = data["Image"] as? String {
                        walletImage = image
                    }
                    if let id = data["ID"] as? String {
                        walletId = id
                    }
                    
                    arrWalletObjects.append(
                        Wallet(ID: walletId ?? "", Name: walletName ?? "", Balance: walletBalance ?? 0, Image: UIImage(named: walletImage ?? "error"), Transaction: []))
                    
                }
                completion(arrWalletObjects,total)
            } else {
                print("document not found")
                completion([],0)
            }
        }
    }
}
