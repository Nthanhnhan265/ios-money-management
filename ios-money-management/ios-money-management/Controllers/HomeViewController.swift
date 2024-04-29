//
//  HomeViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 23/04/2024.
//

import UIKit

class HomeViewController: UIViewController {
//    Dữ liệu giả
    var datas = [Transaction]()
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var btn_income: UIButton!
    @IBOutlet weak var menu_wallets: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//debug
        print("Vào HomeViewController")
//        Set dữ liệu giả
        setWallets()
        HashData()
//
        table_view.dataSource = self
        table_view.delegate = self
        table_view.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        
        
       
    
        
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
    func HashData() {
        if let data1 = Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: "10:20AM", des: "Mua 5 cái quần xì"){
            datas += [data1]
        }
        if let data2 = Transaction(name: "Massage", img: UIImage(named: "Frame1"), balance: 1200000, time: "22:22AM", des: "Massage Phụng Thuỷ"){
            datas += [data2]
        }
        if let data3 = Transaction(name: "Food", img: UIImage(named: "Frame1"), balance: 90000, time: "10:20AM", des: "Ăn sáng dưới gầm cầu"){
            datas += [data3]
        }
        

    }
 


}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
//    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        cell.transaction_img.image = datas[indexPath.row].transactionImage
        cell.transaction_time.text = datas[indexPath.row].transactionTime
        cell.transaction_balance.text = "-"+String(datas[indexPath.row].transactionBalance)+"VND"
        cell.transaction_name.text = datas[indexPath.row].transactionName
        cell.transaction_description.text = datas[indexPath.row].transactionDes
        return cell
    }
    
//    UITableViewDelegate
//    làm 1 hành động nào đó khi click vào 1 đối tượng
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Nội dung: ", String(datas[indexPath.row].transactionName))
        print("Hàng thứ: " + String(indexPath.row))
        
//Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        Lấy màn hình cần chuyển qua
        let view_controller = storyboard.instantiateViewController(withIdentifier: "detail_transaction")
//        set title cho navigation
        view_controller.navigationItem.title = datas[indexPath.row].transactionName
//        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
        navigationController?.pushViewController(view_controller, animated: true)
    }
    
}
