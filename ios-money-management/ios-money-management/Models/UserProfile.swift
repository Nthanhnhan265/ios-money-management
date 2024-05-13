//
//  UserProfile.swift
//  ios-money-management
//
//  Created by AnNguyen on 11/05/2024.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class UserProfile {
    private let UID: String
    private var Fullname: String
    private var Avatar: UIImage?
    private var Wallets = [Wallet]()
    //    MARK: Firestore
    //        Tạo một tham chiếu đến cơ sở dữ liệu Firestore
    
    init(UID: String, Fullname: String, Avatar: UIImage? = nil, Wallets: [Wallet] = [Wallet]()) {
        self.UID = UID
        self.Fullname = Fullname
        self.Avatar = Avatar
        self.Wallets = Wallets
    }
    var getUID:String{
        get{
            return UID
        }
    }
    var getFullname:String{
        get{
            return Fullname
        }
    }
    var getAvatar:UIImage?{
        get{
            return Avatar
        }
    }
    var getWallets:[Wallet]{
        get{
            return Wallets
        }
    }
    
    
    //    MARK: Querry Database Firestore
    
    
    
    
    //------___---___--___-_____---__
    public static func getUserProfine(UID: String) async -> UserProfile? {
        let db = Firestore.firestore()
        let profileRef = db.collection("Profile").document(UID)
        
        do {
            // 1. Lấy thông tin Profile
            let profileDocument = try await profileRef.getDocument()
            if !profileDocument.exists { return nil }
            
            // 2. Lấy dữ liệu từ Profile
            guard let profileData = profileDocument.data() else { return nil }
            
            // 3. Truy vấn collection "Wallets"
            let walletQuerySnapshot = try await profileRef.collection("Wallets").getDocuments()
            
            // 4. Tạo mảng wallets
            var wallets = [Wallet]()
            for walletDocument in walletQuerySnapshot.documents {
                let walletData = walletDocument.data()
                let wallet = Wallet(
                    ID: walletDocument.documentID,
                    Name: walletData["Name"] as? String ?? "",
                    Balance: walletData["Balance"] as? Int ?? 0,
                    Image: nil // Hoặc lấy hình ảnh nếu có trường tương ứng
                )
                wallets.append(wallet)
            }
            
            // 5. Trả về UserProfile (đã có mảng wallets)
            return UserProfile(
                UID: UID,
                Fullname: profileData["Fullname"] as? String ?? "",
                Avatar: UIImage(named: profileData["Avatar"] as? String ?? ""),
                Wallets: wallets
            )
            
        } catch {
            print("Error getting user profile: \(error)")
            return nil // Xử lý lỗi bằng cách trả về nil
        }
    }
    public func ToString(){
        
        
        print("---------")
        print("User: \(UID) - \(Fullname)")
        for i in Wallets{
            print(i.ToString())
        }
        print("---------")
    }
}
