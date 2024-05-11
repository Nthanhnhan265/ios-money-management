//
//  AccountWalletsViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 09/05/2024.
//

import UIKit

class AccountWalletsViewController: UIViewController {

//    Dữ liệu giả
    private var wallets = [Wallet]()
    
    @IBOutlet weak var tbv_wallets: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào AccountWalletsViewController")

        
        self.navigationItem.title = "Wallets"
//        Kết nối table view với các hàm để load dữ liệu
        tbv_wallets.dataSource = self
        tbv_wallets.delegate = self
        tbv_wallets.register(WalletTableViewCell.nib(), forCellReuseIdentifier: WalletTableViewCell.identifier)
        
        setWallets()
        
        
    }
    
//    Hàm set data giả
    func setWallets()  {
//        wallets.append(Wallet(walletName: "Wallet", walletImg: UIImage(named: "Frame1"), walletBalance: 400))
//
//        wallets.append(Wallet(walletName: "Chase", walletImg: UIImage(named: "Frame1"), walletBalance: 1000))
//
//        wallets.append(Wallet(walletName: "City", walletImg: UIImage(named: "Frame1"), walletBalance: 6000))
//
//        wallets.append(Wallet(walletName: "Paypal", walletImg: UIImage(named: "Frame1"), walletBalance: 2000))
//        wallets.append(Wallet(walletName: "Wallet", walletImg: UIImage(named: "Frame1"), walletBalance: 400))
//
//        wallets.append(Wallet(walletName: "Chase", walletImg: UIImage(named: "Frame1"), walletBalance: 1000))
//
//        wallets.append(Wallet(walletName: "City", walletImg: UIImage(named: "Frame1"), walletBalance: 6000))
//
//        wallets.append(Wallet(walletName: "Paypal", walletImg: UIImage(named: "Frame1"), walletBalance: 2000))
//        wallets.append(Wallet(walletName: "Wallet", walletImg: UIImage(named: "Frame1"), walletBalance: 400))
//
//        wallets.append(Wallet(walletName: "Chase", walletImg: UIImage(named: "Frame1"), walletBalance: 1000))
//
//        wallets.append(Wallet(walletName: "City", walletImg: UIImage(named: "Frame1"), walletBalance: 6000))
//
//        wallets.append(Wallet(walletName: "Paypal", walletImg: UIImage(named: "Frame1"), walletBalance: 2000))
    }
    

}
extension AccountWalletsViewController: UITableViewDelegate, UITableViewDataSource{
    //    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Tạo 1 cell từ file xib
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as! WalletTableViewCell
        
//        Đổ dữ liệu vào cell
//        cell.Wallet_name.text = wallets[indexPath.row].walletName
//        cell.Wallet_img.image = wallets[indexPath.row].walletImg
//        cell.Wallet_balace.text = "$"+String(wallets[indexPath.row].walletBalance)
        
        return cell
    }
    //    UITableViewDelegate
    //    làm 1 hành động nào đó khi click vào 1 đối tượng
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            print("Ví \(wallets[indexPath.row].walletName) có \(wallets[indexPath.row].walletBalance) tiền")
        }
        
    
}
