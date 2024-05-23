



//  DetailExpenseViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 16/02/1403 AP.
//

import UIKit

class DetailExpenseViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    

    //MARK: properties
    var transaction:Transaction? = nil
    
    @IBOutlet weak var txt_des: UILabel!
    @IBOutlet weak var txt_wallet: UILabel!
    @IBOutlet weak var txt_category: UILabel!
    @IBOutlet weak var txt_time: UILabel!
    @IBOutlet weak var txt_balance: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var wallets:[Wallet]?
    var detailTrans:Transaction?
    //tao mang 5 tam hinh
    var arrImgs:[UIImage]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFrontEnd()
        
        //        Lấy userProfile đang nằm trong Tabbar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
            if let transaction = transaction{
                setBackEnd(wallet: tabBarController.getWalletFromTransaction(wallet_ID: transaction.getWalletID)!, transaction: transaction)
                self.detailTrans = transaction

            }
            if let userprofile = tabBarController.userProfile  {
                self.wallets = userprofile.Wallets
            }
            
        }
        //them hinh anh
//        arrImgs?.append(UIImage(named: "avatar")!)
//        arrImgs?.append(UIImage(named: "avatar")!)
//        arrImgs?.append(UIImage(named: "avatar")!)
//        arrImgs?.append(UIImage(named: "avatar")!)
//        arrImgs?.append(UIImage(named: "avatar")!)
         
   
        print("## \(String(describing: arrImgs?.count))");

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
//        dateFormatter.locale = Locale(identifier: "vi_VN")
        
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
        txt_balance.text = String(transaction.getBalance.getVNDFormat())
        
//        Set hình ảnh giao dịch
        arrImgs?.append(contentsOf: transaction.Images)
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
    //MARK: events
    
    @IBAction func edit_trans_tapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail_ex = storyboard.instantiateViewController(withIdentifier: "Expense") as! NewExpenseController
        detail_ex.navigationItem.title = "Edit Expense"
        if let wallets = self.wallets {
            detail_ex.wallets = wallets
            detail_ex.selectedWallet = txt_wallet.text
            detail_ex.detail_trans = self.detailTrans
            
        }
        self.navigationController?.pushViewController(detail_ex, animated: true)
     
    }
    
    
    
    // Function to display the confirm dialog
    func showConfirmDialog() {
        let alertController = UIAlertController(title: "Delete transaction", message: "Are you sure you want to delete this transaction?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            Task{
                //                Xoá transaction trên db
                try await Transaction.deleteTransaction(walletID: self.transaction!.getWalletID, transactionID: self.transaction!.getID)
                //                Xoá transaction ở mảng local
                if let tabBarController = self.tabBarController as? TabHomeViewController {
                    if let userProfile = tabBarController.userProfile{
//                        Tìm được ví chứa giao dịch
                        let wallet = userProfile.Wallets.first(where: {
                            $0.getID == self.transaction?.getWalletID
                        })
//                        Tìm giao dịch trong ví đó
                       if let index =  wallet?.getTransactions().firstIndex(where: {
                            $0.getID == self.transaction?.getID
                       }){
                           //                            xoá giao dịch khỏi mảng
                           wallet?.transactions_get_set.remove(at: index)
                       }
                        //                    Cộng trừ tiền lại vào ví
//                         wallet.balance trung gian = wallet.balance trung gian - (self.transaction.balance)
                        tabBarController.userProfile?.Wallets.first(where: {$0.getID == self.transaction?.getWalletID})?.Balance = (tabBarController.userProfile?.Wallets.first(where: {$0.getID == self.transaction?.getWalletID})!.Balance)! - self.transaction!.getBalance
                    }
                }
                //                Trở về màn hình trước
                self.navigationController?.popViewController(animated: true)
            }
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
    
    //MARK: implements
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuse = "DetailCell"
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? DetailExpenseCell {
            cell.imgView.image = arrImgs?[indexPath.row]
            cell.tag = indexPath.row
            return cell 
        }
        
        fatalError("khong the return cell : DetailExpenseViewController")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 10 , height: 128 - 10)
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
