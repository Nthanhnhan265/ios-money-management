//
//  TransactionViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 06/05/2024.
//

import UIKit

class TransactionViewController: UIViewController {
    
   
    @IBOutlet weak var tableview: UITableView!
// Date
    
    
    
    //    Dữ liệu giả
    private var datas = [Transaction]()
    
   
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào TransactionViewController")
        
        //        Setting cho table view
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
       
       
        
        
        
        
        
        
//        if let customDate = date.date(from: customDateString) {
//            print(customDate)
//            self.datas.append(Transaction(name: "Test", img: UIImage(named: "Frame1"), balance: 1, time: customDate, des: ""))
//        }
    }

    
    
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


    
    
}
extension TransactionViewController: UITableViewDataSource, UITableViewDelegate{
//    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
//
        let item = datas[indexPath.row]

//Bỏ thông tin vào các UI của cell
        cell.transaction_name.text = item.transactionName
        cell.transaction_img.image = item.transactionImage
        cell.transaction_description.text = item.transactionDes
        cell.transaction_balance.text = String(12345)
        
        // Assuming cell.transaction_time is a UILabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        cell.transaction_time.text = formattedDate
        return cell
    }
//    Hàm set title TODAY, YESTERDAY...
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(section))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(from: date)
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
