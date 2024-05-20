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
import FirebaseStorage
import SDWebImage


class UserProfile {
    private let UID: String
    private var fullname: String
    private var avatar: UIImage?
    private var wallets = [Wallet]()
    //    MARK: Firestore
    //        Tạo một tham chiếu đến cơ sở dữ liệu Firestore
    
    init(UID: String, fullname: String, avatar: UIImage? = nil, wallets: [Wallet] = [Wallet]()) {
        self.UID = UID
        self.fullname = fullname
        self.avatar = avatar
        self.wallets = wallets
    }
    var getUID:String{
        get{
            return UID
        }
    }
    var Fullname:String{
        get{
            return fullname
        }
        set{
            self.fullname = newValue
        }
    }
    var Avatar:UIImage?{
        get{
            return avatar
        }
        set{
            self.avatar = newValue
        }
    }
    var Wallets:[Wallet]{
        get{
            return wallets
        }
        set{
            wallets = newValue
        }
    }
    
    
    //    MARK: Querry Database Firestore
    public static func updateUserProfile(UID:String, fullname:String, avatarURL: String){
        // Cập nhật thông tin lên Firestore
                let db = Firestore.firestore()
                let profileRef = db.collection("Profile").document(UID)
                profileRef.updateData([
                    "Fullname": fullname,
                    "Avatar": avatarURL
                ]) { error in
                    if let error = error {
                        print("Error updating user profile: \(error)")
                    } else {
                        print("User profile updated successfully!")
                    }
                }
    }
    
    // Hàm tải ảnh lên Firebase Storage và trả về URL
        public static func uploadImageToStorage(imageData: Data, fileName: String) async throws -> String {
            let storageRef = Storage.storage().reference().child("avatars/\(fileName)")
            _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL.absoluteString
        }
    public static func createUserProfile(userProfile: UserProfile) async throws -> String {
        
        let db = Firestore.firestore()
        
        // 1. Tải ảnh đại diện lên Firebase Storage (nếu có)
//        var avatarUrl: String?
//        if let avatarImage = userProfile.getAvatar, let imageData = avatarImage.jpegData(compressionQuality: 0.8) {
//            avatarUrl = try await uploadImageToStorage(imageData: imageData, fileName: "\(userProfile.getUID)_avatar.jpg")
//        }
        
        // 2. Tạo dictionary chứa dữ liệu hồ sơ
        let profileData: [String: Any] = [
            "ID": userProfile.getUID,
            "Fullname": userProfile.Fullname,
            "Avatar": userProfile.Avatar ?? "avatar_default.jpg" // Nếu không có ảnh, lưu chuỗi rỗng
        ]
        
        // 3. Tạo tài liệu mới trong collection "Profile"
        let documentRef = db.collection("Profile").document(userProfile.getUID)
        
        // 4. Ghi dữ liệu vào tài liệu mới
        try await documentRef.setData(profileData)
        
        print("User profile created with ID: \(userProfile.getUID)")
        return userProfile.getUID
    }
    
    
    //------___---___--___-_____---__
    public static func getUserProfine(UID: String) async -> UserProfile? {
        let db = Firestore.firestore()
        let profileRef = db.collection("Profile").document(UID)
        
        do {
                    let snapshot = try await profileRef.getDocument()

                    guard let data = snapshot.data() else { return nil } // Không tìm thấy hồ sơ

            
                    let fullName = data["Fullname"] as? String ?? ""
                    let avatarImage = UIImage(named: data["Avatar"] as? String ?? "avatar_default")
            
            
            print("Truy vấn thành công getUserProfine")
            return await UserProfile(UID: UID, fullname: fullName, avatar: avatarImage, wallets: Wallet.getMyWallets(UID: UID)!)
        } catch {
            print("Lỗi truy vấn - getUserProfine: \(error)")
            return nil
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
