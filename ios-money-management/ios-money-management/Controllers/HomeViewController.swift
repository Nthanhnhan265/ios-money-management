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
    
//    các button: Today, Week, Month, Year
    @IBOutlet weak var btn_week: UIButton!
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_year: UIButton!
    @IBOutlet weak var btn_month: UIButton!
    
//    Button nhập xuất
    @IBOutlet weak var btn_Expenses: UIButton!
    @IBOutlet weak var btn_income: UIButton!
    
//    Pop up button chọn ví
    @IBOutlet weak var menu_wallets: UIButton!
    
//    Biến lưu button nào đang active (Today, Week, Month, Year)
    var activeButton: UIButton?


    
    override func viewDidLoad() {
        super.viewDidLoad()
//debug
        print("Vào HomeViewController")

//        Set dữ liệu giả
        setWallets()
        setTransactions()
//        Kết nối table view với các hàm để load dữ liệu
        table_view.dataSource = self
        table_view.delegate = self
        table_view.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        
//        Set mặc định button Today được active
        btn_today.layer.cornerRadius = 20
        btn_today.clipsToBounds = true
        btn_today.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
        btn_today.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        activeButton = btn_today
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Load lại HomeViewController")
        self.tabBarController?.tabBar.isHidden = false

        
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
    @IBAction func btn_expenses(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view_controller = storyboard.instantiateViewController(withIdentifier: "Expense") as! NewExpenseController
        view_controller.navigationItem.title = "Expense"
        navigationController?.pushViewController(view_controller, animated: true)
    }
    @IBAction func btn_income_click(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view_controller = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        view_controller.navigationItem.title = "Income"
        navigationController?.pushViewController(view_controller, animated: true)
    }
    func setTransactions() {
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
// click btn week
    @IBAction func btn_week_click(_ sender: UIButton) {
//        Trả active button cũ về trạng thái ban đầu
        if activeButton != nil{
            activeButton?.layer.cornerRadius = 0
            activeButton?.clipsToBounds = false
            activeButton?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        }
        activeButton = btn_week
        activeButton?.layer.cornerRadius = 20
        activeButton?.clipsToBounds = true
        activeButton?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
        activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        
        
        
    }
    // click btn today
    @IBAction func btn_today_clik(_ sender: UIButton) {
        //        Trả active button cũ về trạng thái ban đầu
                if activeButton != nil{
                    activeButton?.layer.cornerRadius = 0
                    activeButton?.clipsToBounds = false
                    activeButton?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                    activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                }
                activeButton = btn_today
                activeButton?.layer.cornerRadius = 20
                activeButton?.clipsToBounds = true
                activeButton?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
                activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                
                
                

    }
    // click btn month

    @IBAction func btn_month_click(_ sender: UIButton) {
        //        Trả active button cũ về trạng thái ban đầu
                if activeButton != nil{
                    activeButton?.layer.cornerRadius = 0
                    activeButton?.clipsToBounds = false
                    activeButton?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                    activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                }
                activeButton = btn_month
                activeButton?.layer.cornerRadius = 20
                activeButton?.clipsToBounds = true
                activeButton?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
                activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                
                
    }
    // click btn year
    @IBAction func btn_year_click(_ sender: UIButton) {
        //        Trả active button cũ về trạng thái ban đầu
                if activeButton != nil{
                    activeButton?.layer.cornerRadius = 0
                    activeButton?.clipsToBounds = false
                    activeButton?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                    activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                }
                activeButton = btn_year
                activeButton?.layer.cornerRadius = 20
                activeButton?.clipsToBounds = true
                activeButton?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
                activeButton?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
                
                

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
