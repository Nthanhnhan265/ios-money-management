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
    private let ID:String
    private var Name: String
    private var Balance: Int
    private  var Image: UIImage?
    
    init(ID: String, Name: String, Balance: Int, Image: UIImage? ) {
        self.ID = ID
        self.Name = Name
        self.Balance = Balance
        self.Image = Image
    }
    var getID:String{
        get{
            return ID
            
        }
    }
    var getName:String{
        get{
            return Name
        }
    }
    var getBalance:Int{
        get{
            return Balance
        }
    }
    var getImage:UIImage?{
        get{
            return Image
        }
    }

    public func ToString(){
        print("Wallet: \(ID) - \(Name) - \(Balance)")
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
                    
                    arrWalletObjects.append(Wallet(ID: walletId ?? "", Name: walletName ?? "", Balance: walletBalance ?? 0, Image: UIImage(named: walletImage ?? "error")))
                     
                }
                completion(arrWalletObjects,total)
            } else {
                print("document not found")
                completion([],0)
            }
        }
    }
}
