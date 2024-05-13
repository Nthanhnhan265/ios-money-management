//
//  DetailWalletViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 10/05/2024.
//

import UIKit

class DetailWalletViewController: UIViewController {

//    Dữ liệu giả
    private var datas = [Transaction]()
    @IBOutlet weak var tableview: UITableView!

    var sections: [Section] = [
        Section(date: Date(), transactions: [
//            Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: Date(), des: "123"),
//            Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: Date(), des: "") ,
        ]),
        Section(date: Date().addingTimeInterval(-24 * 60 * 60), transactions: [
//            Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: Date().addingTimeInterval(-24 * 60 * 60), des: ""),
//            Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: Date().addingTimeInterval(-24 * 60 * 60), des: ""),
        ]),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Vào DetailWalletViewController")
        
//        set dữ liệu cho table
        //        Setting cho table view
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        
        
        setDataTransaction()
    }
    


}
extension DetailWalletViewController: UITableViewDataSource, UITableViewDelegate{
//    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datas.count
        return sections[section].transactions.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        let item = datas[indexPath.row]

//Bỏ thông tin vào các UI của cell
//        cell.transaction_name.text = item.transactionName
//        cell.transaction_img.image = item.transactionImage
//        cell.transaction_description.text = item.transactionDes
//        cell.transaction_balance.text = String(-12345)
//        cell.transaction_time.text = DateToString(item.transactionTime!)
            
        return cell
    }
//    Hàm set title TODAY, YESTERDAY...
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: sections[section].date)
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
        func setDataTransaction() {
            for i in 10..<30{
                if let time = StringToDate("\(i)/05/2024"){
//                    datas.append( Transaction(name: "Shopping", img: UIImage(named: "Frame1"), balance: 120000, time: time, des: ""))
                }
            }
            
            
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
struct Section {
    let date: Date
    let transactions: [Transaction]
}
