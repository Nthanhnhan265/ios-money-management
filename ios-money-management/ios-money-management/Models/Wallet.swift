//
//  Wallet.swift
//  ios-money-management
//
//  Created by AnNguyen on 09/05/2024.
//

import Foundation
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
}
