//
//  TabHomeViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 27/04/2024.
//

import UIKit

class TabHomeViewController: UITabBarController {
    var userProfile:UserProfile? = nil
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userProfile = userProfile{
                        print("TabHomeViewController - \(userProfile.getFullname)")
            
           
            
        }
        
        
    }
    public  func getWalletFromTransaction(wallet_ID:String)->Wallet?{
        if let userProfile = self.userProfile{
            for wallet in userProfile.getWallets{
                if wallet.getID == wallet_ID{
                    return wallet
                }
            }
        }
        return nil
    }
   
    

   
}
