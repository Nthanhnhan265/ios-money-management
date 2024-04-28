//
//  HomeViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 23/04/2024.
//

import UIKit

class HomeViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var btn_income: UIButton!
    @IBOutlet weak var menu_wallets: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Vào HomeViewController")
        setWallets()
        
        self.navigationItem.title = "title"

        
    
        
    }
    func setWallets() {
        let optionClosure = { (action: UIAction) in
             print(action.title)
           }

        menu_wallets.menu = UIMenu(children: [
             UIAction(title: "Tổng cộng", state: .on, handler: optionClosure),
             UIAction(title: "MB Bank", handler: optionClosure),
             UIAction(title: "Tiền mặt", handler: optionClosure),
           ])
    }


}

