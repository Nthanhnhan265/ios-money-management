//
//  AccountWalletsViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 09/05/2024.
//

import UIKit

class AccountWalletsViewController: UIViewController {
    private var wallets:[Wallet]?
    let UID = UserDefaults.standard.string(forKey: "UID")
    
    @IBOutlet weak var tbv_wallets: UITableView!
    @IBOutlet weak var totalBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào AccountWalletsViewController")
        
        
       Wallet.getAllWallets(UID: UID!){
            arrWallets, totalBalance in
           if !arrWallets.isEmpty {
               self.wallets = arrWallets
               self.totalBalance.text = "$\(totalBalance)"
               self.tbv_wallets.reloadData()
           }
        }
        self.navigationItem.title = "Wallets"
//        Kết nối table view với các hàm để load dữ liệu
        tbv_wallets.dataSource = self
        tbv_wallets.delegate = self
        tbv_wallets.register(WalletTableViewCell.nib(), forCellReuseIdentifier: WalletTableViewCell.identifier)
        
        tabBarController?.tabBar.isHidden = true
//        setWallets()
        
        
    }
    //ham duoc goi de reset navbar
    override func viewWillAppear(_ animated: Bool) {
        setNavbar()
    }
    //Ham set navbar
    func setNavbar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.backgroundColor = .white
    }
//    Hàm set data giả
    func setWallets()  {
//        wallets.append(Wallet(ID: "1", Name: "MBB", Balance: 100000, Image: UIImage(named: "Frame1")))
//        wallets.append(Wallet(ID: "1", Name: "MBB", Balance: 100000, Image: UIImage(named: "Frame1")))
//        wallets.append(Wallet(ID: "1", Name: "MBB", Balance: 100000, Image: UIImage(named: "Frame1")))
//        wallets.append(Wallet(ID: "1", Name: "MBB", Balance: 100000, Image: UIImage(named: "Frame1")))
//        wallets.append(Wallet(ID: "1", Name: "MBB", Balance: 100000, Image: UIImage(named: "Frame1")))
    }
    
//    MARK: Add new wallet
    @IBAction func btn_NewWallet_Tapped(_ sender: UIButton) {
        //Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        Lấy màn hình cần chuyển qua
        let view_controller = storyboard.instantiateViewController(withIdentifier: "NewWallet")
        view_controller.isEditing = false //isEditing = false khi vao man hinh them
        //        set title cho navigation
        view_controller.navigationItem.title = "New Wallet"
        //        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
        navigationController?.pushViewController(view_controller, animated: true)
        //        self.present(view_controller, animated: true)
    }
    

}
extension AccountWalletsViewController: UITableViewDelegate, UITableViewDataSource{
    //    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.wallets?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Tạo 1 cell từ file xib
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as! WalletTableViewCell
        
//        Đổ dữ liệu vào cell
        cell.Wallet_name.text = self.wallets![indexPath.row].getName
        cell.Wallet_img.image = self.wallets![indexPath.row].getImage
        cell.Wallet_balace.text = "$"+String(self.wallets![indexPath.row].Balance)
        
        return cell
    }
    //    UITableViewDelegate
    //    làm 1 hành động nào đó khi click vào 1 đối tượng
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            print("Ví \(wallets[indexPath.row].walletName) có \(wallets[indexPath.row].walletBalance) tiền")
        }
        
    
    
}
