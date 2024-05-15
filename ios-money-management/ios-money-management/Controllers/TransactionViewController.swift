//
//  TransactionViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 06/05/2024.
//

import UIKit

class TransactionViewController: UIViewController {
//    Cấu trúc để chia giao dịch theo ngày
    struct Section {
        let date: Date
        let transactions: [Transaction]
    }
//    MARK: Properties
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var popup_time: UIButton!
    @IBOutlet weak var view_rangeTime: UIView!
    @IBOutlet weak var popup_cate: UIButton!
    @IBOutlet weak var view_filter: UIView!
    
    //    Dữ liệu
    private var datas = [Transaction]()
    private var wallets = [Wallet]()
    var sections: [Section] = [
        Section(date: Date(), transactions: [
        ]),
        Section(date: Date().addingTimeInterval(-24 * 60 * 60), transactions: [
        ]),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào TransactionViewController")
        
        //       Lấy UID
        let UID = UserDefaults.standard.string(forKey: "UID") ?? ""
        
//        Đọc toàn bộ user profile
        Task{
            if let userProfile = await UserProfile.getUserProfine(UID: UID){
                
                
                //                Set transactions
                for wallet in userProfile.getWallets{
                    setDataTransaction(transactions: wallet.getTransactions)
                    
                    
                }
                // Reload table view on main thread
                await MainActor.run {
                    datas.sort{ $0.getCreateAt > $1.getCreateAt }
                    tableview.reloadData()
                }
            }
          
            
        }


        //        Setting cho table view
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableview.register(IncomeCell.nib(), forCellReuseIdentifier: IncomeCell.identifier)
        
//        setDataTransaction()
//        setCategory()
//        setTimeline()
    }
    func setTimeline()  {
        let optionClosure = { (action: UIAction) in
             print(action.title)
           }

        popup_time.menu = UIMenu(children: [
             UIAction(title: "Tháng", state: .on, handler: optionClosure),
             UIAction(title: "Ngày", handler: optionClosure),
             UIAction(title: "Năm", handler: optionClosure),
           ])
    }
    
    @IBAction func btn_rangeTime_Tapped(_ sender: UIBarButtonItem) {
        view_rangeTime.isHidden = !view_rangeTime.isHidden
        
    }
    func setCategory()  {
        let optionClosure = { (action: UIAction) in
             print(action.title)
           }

        popup_cate.menu = UIMenu(children: [
             UIAction(title: "Tổng cộng", state: .on, handler: optionClosure),
             UIAction(title: "MB Bank", handler: optionClosure),
             UIAction(title: "Tiền mặt", handler: optionClosure),
           ])
    }
    /// Hàm chuyển đồ từ Date sang String
    func DateToString(_ date:Date) -> String{
        //      Lấy ra 1 biến Date ở thời gian hiện tại
        let currentDateAndTime = date
        //        Tạo ra 1 biến format
        let dateFormatter = DateFormatter()
        
        //        Ngày: 5/9/24
        dateFormatter.dateStyle = .short
        
        //        Giờ none
        dateFormatter.timeStyle = .none
        
        //        Địa điểm
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        //09/05/2024
//        print(dateFormatter.string(from: currentDateAndTime))
//        Date -> String
//        print(type(of: dateFormatter.string(from: currentDateAndTime)))
        
        
        return dateFormatter.string(from: currentDateAndTime)
    }
    /// Hàm Chuyển đổi từ String sang Date
    func StringToDate(_ str_date:String) -> Date? {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        if let rs = dateFormatter.date(from: str_date){
            

            return rs
        }
        else
        {
            print("<<<<<String to Date KHÔNG THÀNH CÔNG - TransactionViewController>>>>>")
            return Date.now
        }
    }
//    Hàm set dữ liệu giả cho ví
    func setDataTransaction(transactions: [Transaction]) {
      
        for i in transactions{
            datas.append(i)
        }
        
    }

    @IBAction func btn_filter_tapped(_ sender: UIBarButtonItem) {
        view_filter.isHidden = !view_filter.isHidden
    }
    
    
    
}
extension TransactionViewController: UITableViewDataSource, UITableViewDelegate{
//    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
//        return sections[section].transactions.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Màu đỏ
        if !(self.datas[indexPath.row].getCategory.getinCome){
            let cell = tableview.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
            let item = datas[indexPath.row]

    //Bỏ thông tin vào các UI của cell
            cell.transaction_name.text = self.datas[indexPath.row].getCategory.getName
            cell.transaction_img.image = self.datas[indexPath.row].getCategory.getImage
            cell.transaction_description.text = self.datas[indexPath.row].getDescription
            cell.transaction_balance.text = String(self.datas[indexPath.row].getBalance)
            cell.transaction_time.text = DateToString(self.datas[indexPath.row].getCreateAt)
            return cell
        }
        else{
            let cell = tableview.dequeueReusableCell(withIdentifier: IncomeCell.identifier, for: indexPath) as! IncomeCell
            let item = datas[indexPath.row]

    //Bỏ thông tin vào các UI của cell
            cell.trans_income_name.text = self.datas[indexPath.row].getCategory.getName
            cell.trans_income_image.image = self.datas[indexPath.row].getCategory.getImage
            cell.trans_income_des.text = self.datas[indexPath.row].getDescription
            cell.trans_income_balance.text = String(self.datas[indexPath.row].getBalance)
            cell.trans_income_time.text = DateToString(self.datas[indexPath.row].getCreateAt)
                
            return cell
        }
        
    }
//    Hàm set title TODAY, YESTERDAY...
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: sections[section].date)
    }

    
    //  UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(datas[indexPath.row])
        
//        Chuyển màn hình
        //Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        Lấy màn hình cần chuyển qua
        let view_controller = storyboard.instantiateViewController(withIdentifier: "detail_transaction")
        //        set title cho navigation
//        view_controller.navigationItem.title = datas[indexPath.row]

        //        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
        navigationController?.pushViewController(view_controller, animated: true)
    }
}

