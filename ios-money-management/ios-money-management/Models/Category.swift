//
//  Category.swift
//  ios-money-management
//
//  Created by AnNguyen on 12/05/2024.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
class Category{
    private let ID:String
    private let Name:String
    private let Image: UIImage?
    private let inCome: Bool
    
    init(ID: String, Name: String, Image: UIImage?, inCome: Bool) {
        self.ID = ID
        self.Name = Name
        self.Image = Image
        self.inCome = inCome
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
    var getinCome:Bool{
        get{
            return inCome
        }
    }
    var getImage:UIImage?{
        get{
            return Image
        }
    }
    public static func getCategory(Category_ID:String) async -> Category?{
        let db = Firestore.firestore()
        let categoryRef = db.collection("Category").document(Category_ID)
        
        do{
            let snapshot = try await categoryRef.getDocument() // Lấy tất cả documents
            guard let data = snapshot.data() else { return nil } // Không tìm thấy hồ sơ
            
            return  Category(ID: data["ID"] as! String, Name: data["Name"] as! String , Image: UIImage(named: data["Image"] as! String), inCome: data["isIncome"] as! Bool)

        }
        catch{
            print("Lỗi truy vấn - getCategory: \(error)")
            return nil        }
    }
    public static func getExpenses() async -> [Category] {
        let db = Firestore.firestore()
        let cateRef = db.collection("Category").whereField("isIncome", isEqualTo: false)
        var incomes = [Category]()
        do {
            let querySnapshot = try await cateRef.getDocuments()
            for document in querySnapshot.documents {
                let data = document.data()
                incomes.append(Category(ID: data["ID"] as! String, Name: data["Name"] as! String, Image: UIImage(named: data["Image"] as! String), inCome: true))
            }
        } catch {
            print("Lỗi khi truy vấn: \(error)")
            // Xử lý lỗi tại đây
        }
        return incomes
        
        //        let db = Firestore.firestore()
        //        let cateRef = db.collection("Category")
        //
        //        cateRef.getDocuments() { (querySnapshot, err) in
        //            var income = [Category]()
        //            var express = [Category]()
        //
        //            if let err = err {
        //                print("Lỗi khi truy vấn: \(err)")
        //                completion([]) // Trả về mảng rỗng nếu có lỗi
        //                return
        //            } else {
        //                for document in querySnapshot!.documents {
        //                    let data = document.data()
        //                    if (data["isIncome"]! as! Bool) == true {
        //                        income.append(Category(ID: data["ID"] as! String, Name: data["Name"] as! String, Image: UIImage(named: data["Image"] as! String), inCome: true))
        //                    } else {
        //                        express.append(Category(ID: data["ID"] as! String, Name: data["Name"] as! String, Image: UIImage(named: data["Image"] as! String), inCome: false))
        //                    }
        //                }
        //            }
        //            completion(getIncome ? income : express)
        //        }
    }
    
    //    public static func getAllCate(getIncome:Bool) -> [Category]{
    //        // Tham chiếu đến Firestore
    //        let db = Firestore.firestore()
    //
    //        // Tham chiếu đến Collection "users"
    //        let cateRef = db.collection("Category")
    //
    //        var income = [Category]()
    //        var express = [Category]()
    //
    //        // Truy vấn tất cả Document
    //        cateRef.getDocuments() { (querySnapshot, err) in
    //            if let err = err {
    //                print("Lỗi khi truy vấn: \(err)")
    //            } else {
    //                for document in querySnapshot!.documents {
    //                    let data = document.data()
    //                    // Xử lý dữ liệu của từng Document ở đây
    ////                    print("\(document.documentID) => \(data)")
    ////
    ////                    print(data["ID"]!)
    ////                    print(data["Name"]!)
    ////                    print()
    ////                    print(data["Image"]!)
    //
    //                    //                    Thu nhập
    //                    if (data["isIncome"]! as! Bool) == true{
    //                        income.append(Category(
    //                            ID: data["ID"] as! String ,
    //                            Name: data["Name"] as! String ,
    //                            Image: UIImage(named: data["Image"] as! String ),
    //                            inCome: true)
    //                        )
    //                    }
    //                    else{
    //                        express.append(Category(
    //                            ID: data["ID"] as! String ,
    //                            Name: data["Name"] as! String ,
    //                            Image: UIImage(named: data["Image"] as! String ),
    //                            inCome: true)
    //                        )
    //                    }
    //
    //
    //                }
    //            }
    //            if getIncome{
    //                return income
    //            }
    //            return express
    //        }
    //
    //    }
    
}
