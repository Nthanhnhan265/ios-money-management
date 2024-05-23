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
import FirebaseStorage

class Transaction  {
    private let id:String
    private var description:String
    private var balance: Int
    private let category: Category
    private let create_at:Date
    private let wallet_id: String
    private  var images: [UIImage]?
    public func toString(){
        print("\(self.id) - \(self.description) - \(self.balance) - \(self.category.getName) - \(self.create_at) || Ví \(wallet_id)")
    }
    var getID:String{
        get{
            return id
            
        }
    }
    var Images:[UIImage]{
        get{
            return self.images!
        }
        set{
            self.images = newValue
        }
    }
    var getWalletID:String{
        get{
            return wallet_id
            
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
    
    init(id: String, description: String, balance: Int, category: Category, create_at: Date, wallet_id: String, images: [UIImage]) {
        self.id = id
        self.description = description
        self.balance = balance
        self.category = category
        self.create_at = create_at
        self.wallet_id = wallet_id
        self.images = images
    }
    
   public static func uploadImagesToStorage(images: [UIImage]) async throws -> [String] {
        var imageUrls: [String] = []
        let storageRef = Storage.storage().reference()

        for image in images {
            // Tạo đường dẫn lưu trữ trên Storage (ví dụ: images/tên_file.jpg)
            let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")

            // Chuyển đổi UIImage thành Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error converting image to data"])
            }

            // Tải ảnh lên Storage
            _ = try await imageRef.putDataAsync(imageData)

            // Lấy URL của ảnh
            let downloadURL = try await imageRef.downloadURL()
            imageUrls.append(downloadURL.absoluteString)
        }

        return imageUrls
    }

    public static func getAllMyTransactions(walletID:String) async -> [Transaction]?{
        let db = Firestore.firestore()
        let walletRef = db.collection("Transactions").document(walletID).collection("Transaction")
        var myTransactions = [Transaction]()
        
        do {
            let snapshot = try await walletRef.getDocuments() // Lấy tất cả documents
            
//            Duyệt mảng transaction
            for transaction in snapshot.documents{
                var arr_image_transaction:[UIImage] = []
//                Duyệt ảnh của 1 transaction
                for image_url in transaction["imageUrls"] as! Array<String>{
                    guard let imageUrl = URL(string: image_url) else {
                            print("Download ảnh thất bại")
                            return nil
                        }
                    do {
                        // Tải dữ liệu ảnh (Data) từ URL
                        let (imageData, _) = try await URLSession.shared.data(from: imageUrl)

                        // Chuyển đổi dữ liệu ảnh thành UIImage
                        if let image = UIImage(data: imageData) {
                            arr_image_transaction.append(image)
                        }
                    } catch {
                        print("Error loading image: \(error.localizedDescription)")
                        return nil
                    }

                }
                await myTransactions.append(
                    Transaction(
                        id: transaction["ID"] as! String,
                        description:  transaction["Description"] as! String,
                        balance: transaction["Balance"] as! Int,
                        category: Category.getCategory(Category_ID: transaction["Category_ID"] as! String)!,
                        create_at: (transaction["CreateAt"] as? Timestamp)?.dateValue() ?? Date(),
                        wallet_id: walletID,
                        images:arr_image_transaction
                    )
                )
            }
            
            return myTransactions
        } catch {
            print("Lỗi truy vấn - getMyWallets: \(error)")
            return nil
        }
    }
    public static func deleteTransaction(walletID: String, transactionID: String) async throws {
        let db = Firestore.firestore()
        
        // 1. Lấy  giao dịch collection "Transaction"
        let transactionRef = db.collection("Transactions").document(walletID).collection("Transaction").document(transactionID)
        
        // 2. Xóa ảnh khỏi Firebase Storage (nếu có)
        let transactionData = try await transactionRef.getDocument() // Lấy lại dữ liệu giao dịch
        if let imageUrls = transactionData.get("imageUrls") as? [String] {
            print(imageUrls)
            for imageUrl in imageUrls {
                try await deleteImageFromStorage(urlString: imageUrl)
            }
        }
        //       Xoá giao dịch
        try await transactionRef.delete()
        
        print("Transaction deleted successfully!")
    }

        // Hàm xóa ảnh từ Firebase Storage
        private static func deleteImageFromStorage(urlString: String) async throws {
            guard let _ = URL(string: urlString) else {return}
            let storageRef = Storage.storage().reference(forURL: urlString)
            try await storageRef.delete()
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
//        dateFormatter.locale = Locale(identifier: "vi_VN")
        
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
    ///Hàm ghi 1 giao dịch mới lên DB trong wallet_id
    ///Và trả về 1 String là ID của giao dịch mới được khởi tạo
    public static func addTransaction(wallet_id:String, balance:Int, category_id:String, des:String, images: [UIImage], created_at:Date )async throws -> String{
            let db = Firestore.firestore()
            
            // Tạo một DocumentReference để lấy ID sau khi document được tạo
            let transactionRef = db.collection("Transactions").document(wallet_id).collection("Transaction").document()
            
        // Tải ảnh lên Storage và lấy URL
        let imageUrls = try await uploadImagesToStorage(images: images)
        
            let transactionData: [String: Any] = [
                "Balance": balance,
                "Category_ID": category_id,
                "Description": des,
                "CreateAt": created_at,
                "imageUrls": imageUrls // Lưu mảng URL vào Firestore

            ]
            // Sử dụng transactionRef để thêm document
            try await transactionRef.setData(transactionData)

            // Cập nhật lại document với trường ID
            try await transactionRef.updateData(["ID": transactionRef.documentID])
            print("Transaction added successfully!")

            return transactionRef.documentID // Trả về ID giao dịch mới
        


        
    }
  

}
