//
//  TransactionViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 06/05/2024.
//

import UIKit

class TransactionViewController: UIViewController {
    
    
    
    @IBOutlet weak var btn_FilterBy: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào TransactionViewController")

        setFilterBy()
    }
    
    @IBAction func onChange_FilterBy(_ sender: UIBarButtonItem) {
        print("Click UIBarButtonItem! ")
    }
    
    func setFilterBy()  {
        let optionClosure = { (action: UIAction) in
             print(action.title)
           }

        btn_FilterBy.menu = UIMenu(children: [
             UIAction(title: "Tổng cộng", state: .on, handler: optionClosure),
             UIAction(title: "MB Bank", handler: optionClosure),
             UIAction(title: "Tiền mặt", handler: optionClosure),
           ])

    }

}
