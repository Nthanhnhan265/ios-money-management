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
    public var Wallets = [Wallet]()
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
    
    
    //    MARK: Querry Database Firestore
    
    
//    public static func getUserProfine(UID: String, completion: @escaping (UserProfile?) -> Void)  {
//        let db = Firestore.firestore()
//
//
//
//        let ProfileRef = db.collection("Profile").document(UID)
//        ProfileRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//
//                let userProfile = UserProfile(
//                    UID: UID,
//                    Fullname: data?["Fullname"] as? String ?? "",
//                    Avatar: UIImage(named: data?["Avatar"] as? String ?? "")
//
//                )
//
//
//                // Truyền UserProfile đến completion handler
//                completion(userProfile)
//            } else {
//                completion(nil) // Truyền nil nếu có lỗi hoặc không có tài liệu
//            }
//        }
//    }
    public static func getUserProfine(UID: String, completion: @escaping (UserProfile?) -> Void) {
        let db = Firestore.firestore()

        let profileRef = db.collection("Profile").document(UID)

        // Lấy thông tin Profile trước
        profileRef.getDocument { (profileDocument, error) in
            if let profileDocument = profileDocument, profileDocument.exists {
                let profileData = profileDocument.data()

                // Bây giờ, truy vấn collection "Wallets"
                profileRef.collection("Wallets").getDocuments { (walletQuerySnapshot, walletError) in
                    if let walletError = walletError {
                        print("Error getting wallets: \(walletError)")
                        completion(nil) // Hoặc có thể xử lý lỗi khác
                        return
                    }

                    var wallets = [Wallet]()
                    for walletDocument in walletQuerySnapshot!.documents {
                        let walletData = walletDocument.data()
                        let wallet = Wallet(
                            ID: walletDocument.documentID, // Lấy ID từ documentID
                            Name: walletData["Name"] as? String ?? "",
                            Balance: walletData["Balance"] as? Int ?? 0,
                            Image: nil // Hoặc lấy hình ảnh nếu có trường tương ứng
                        )
                        wallets.append(wallet)
                    }

                    let userProfile = UserProfile(
                        UID: UID,
                        Fullname: profileData?["Fullname"] as? String ?? "",
                        Avatar: UIImage(named: profileData?["Avatar"] as? String ?? ""),
                        Wallets: wallets
                    )

                    completion(userProfile) // Truyền UserProfile (đã có mảng wallets)
                }
            } else {
                completion(nil)
            }
        }
    }

}
