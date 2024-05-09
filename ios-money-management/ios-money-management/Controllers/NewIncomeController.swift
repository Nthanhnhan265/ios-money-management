//
//  NewIncomeController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 09/02/1403 AP.
//

import UIKit

class NewIncomeController: UIViewController {

    @IBOutlet weak var popupWalletButton: UIButton!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var popupCategoryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào NewIncomeController")
        //button custom
        // Thiết lập tiêu đề của nut
              let attributedTitleCategory = NSAttributedString(string: "Category")
              popupCategoryButton.setAttributedTitle(attributedTitleCategory, for: .normal)
        
        let attributedTitleWallet = NSAttributedString(string: "Wallet")
        popupWalletButton.setAttributedTitle(attributedTitleWallet, for: .normal)
        //chinh mau chu cho textfield $0
        textFieldValue.attributedPlaceholder = NSAttributedString(string: "$0",attributes: [.foregroundColor: UIColor.white])
        
        // Thiết lập các thuộc tính cho các nút khác
               popupCategoryButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               popupCategoryButton.layer.borderWidth = 1
               popupCategoryButton.layer.cornerRadius = 6
               
               popupWalletButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               popupWalletButton.layer.borderWidth = 1
               popupWalletButton.layer.cornerRadius = 6
               
               addImageButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               addImageButton.layer.borderWidth = 1
               addImageButton.layer.cornerRadius = 6
  
        self.setPopupCategoryButton()
        self.setPopupWalletButton()
        
//        Xoá navigation bottom
        self.tabBarController?.tabBar.isHidden = true

    }
    
    
    func setPopupCategoryButton() {
        //thay doi title moi khi chon
        let optionClosure = {(action: UIAction) in
            let attributedTitle = NSAttributedString(string: action.title)
         
            self.popupCategoryButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        //hien thi ra option
        popupCategoryButton.menu = UIMenu(children: [
            UIAction(title: "option 1", handler: optionClosure),
            UIAction(title: "option 2", handler: optionClosure),
            UIAction(title: "option 3", handler: optionClosure)
        ])
        popupCategoryButton.showsMenuAsPrimaryAction = true
        popupCategoryButton.changesSelectionAsPrimaryAction = true
    }
    
    func setPopupWalletButton() {
        //thay doi title moi khi chon
        let optionClosure = {(action: UIAction) in
            let attributedTitle = NSAttributedString(string: action.title)
         
            self.popupWalletButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        //hien thi ra option
        popupWalletButton.menu = UIMenu(children: [
            UIAction(title: "option 1", handler: optionClosure),
            UIAction(title: "option 2", handler: optionClosure),
            UIAction(title: "option 3", handler: optionClosure)
        ])
        popupWalletButton.showsMenuAsPrimaryAction = true
        popupWalletButton.changesSelectionAsPrimaryAction = true
    }
    
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     @IBAction func popupWalletButton(_ sender: UIButton) {
     }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
