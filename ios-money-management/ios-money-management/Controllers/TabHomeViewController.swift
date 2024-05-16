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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
