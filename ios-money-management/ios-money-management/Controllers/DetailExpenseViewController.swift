



//  DetailExpenseViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 16/02/1403 AP.
//

import UIKit

class DetailExpenseViewController: UIViewController {

    //MARK: properties
    var transaction:Transaction? = nil
    
    @IBOutlet weak var txt_des: UILabel!
    @IBOutlet weak var txt_wallet: UILabel!
    @IBOutlet weak var txt_category: UILabel!
    @IBOutlet weak var txt_time: UILabel!
    @IBOutlet weak var txt_balance: UILabel!
    @IBOutlet weak var borderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setFrontEnd()
        
        //        Lấy userProfile đang nằm trong Tabbar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
            if let transaction = transaction{
                setBackEnd(wallet: tabBarController.getWalletFromTransaction(wallet_ID: transaction.getWalletID)!, transaction: transaction)
            }
            
            
        }
        
        
    }
    /// Hàm chuyển đồ từ Date sang String
    func DateToString(_ date:Date) -> String{
        // Lấy ra 1 biến Date ở thời gian hiện tại
        let currentDateAndTime = date
        // Tạo ra 1 biến format
        let dateFormatter = DateFormatter()
        
        // Ngày: 5/9/24
        dateFormatter.dateStyle = .full
        
        // Giờ none
        dateFormatter.timeStyle = .none
        
        // Địa điểm
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        //09/05/2024
        // print(dateFormatter.string(from: currentDateAndTime))
        // Date -> String
        // print(type(of: dateFormatter.string(from: currentDateAndTime)))
        
        
        return dateFormatter.string(from: currentDateAndTime)
    }
    func setBackEnd(wallet:Wallet, transaction:Transaction){
        txt_des.text = transaction.getDescription
        txt_wallet.text = wallet.getName
        txt_category.text = transaction.getCategory.getName
        txt_time.text = DateToString(transaction.getCreateAt)
        txt_balance.text = String(transaction.getBalance)
        
    }
    func setFrontEnd(){
        //set background for navigation controller
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 253/255, green: 74/255, blue: 92/255, alpha: 1);
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //custom border of UIVIew
        borderView.layer.borderColor = CGColor(red: 241/250, green: 241/250, blue: 250/250, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func deleteTransaction(_ sender: UIBarButtonItem) {
        self.showConfirmDialog();
    }
    
    // Function to display the confirm dialog
    func showConfirmDialog() {
        let alertController = UIAlertController(title: "Delete transaction", message: "Are you sure you want to delete this transaction?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            // Perform deletion action here
            print("transaction deleted")
        }
        alertController.addAction(deleteAction)
        
        // Configure presentation style as custom
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
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
