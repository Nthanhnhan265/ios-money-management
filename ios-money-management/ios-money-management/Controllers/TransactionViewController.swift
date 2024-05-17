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
        var transactions: [Transaction]
    }
    //    MARK: Properties
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var popup_time: UIButton!
    @IBOutlet weak var view_rangeTime: UIView!
    @IBOutlet weak var popup_cate: UIButton!
    @IBOutlet weak var view_filter: UIView!
    
    //    Dữ liệu
    private var transactions = [Transaction]()
    private var wallets = [Wallet]()
    var sections: [Section] = [
        //        Section(date: Date(), transactions: [
        //        ]),
        //        Section(date: Date().addingTimeInterval(-24 * 60 * 60), transactions: [
        //        ]),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lấy UID
        let UID = UserDefaults.standard.string(forKey: "UID") ?? ""
        
        
        //debug
        print("Vào TransactionViewController - \(UID)")
        
        //        Lấy userProfile đang nằm trong Tabbar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
            // Truy cập dữ liệu trong TabBarController
            if let userProfile = tabBarController.userProfile
            {
                for wallet in userProfile.getWallets {
                    setTransactions(data: wallet.getTransactions())
                }
                //                Sắp xếp mới nhất
                transactions.sort { $0.getCreateAt > $1.getCreateAt }
                
                //                Lọc transactions theo ngày
                sections = createSections(from: transactions)
            }
            
        }
        
        
        
        //        Setting cho table view
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        //        setDataTransaction()
        //        setCategory()
        //        setTimeline()
    }
    func createSections(from transactions: [Transaction]) -> [Section] {
        var sections: [Section] = []
        var currentSection: Section?
        
        for transaction in transactions {
            let date = Calendar.current.startOfDay(for: transaction.getCreateAt)
            
            // Check if currentSection is nil or the date has changed
            if currentSection == nil || currentSection!.date != date {
                // If the currentSection has transactions, append it to sections
                if let section = currentSection, !section.transactions.isEmpty {
                    sections.append(section)
                }
                // Create a new Section for the new date
                currentSection = Section(date: date, transactions: [])
            }
            
            // Add transaction to the current section
            currentSection?.transactions.append(transaction)
        }
        
        // Append the last section if it contains transactions
        if let section = currentSection, !section.transactions.isEmpty {
            sections.append(section)
        }
        
        return sections
    }
    
    //    func createSections(from transactions: [Transaction]) -> [Section] {
    ////        Mảng sẽ return về
    //        var sections: [Section] = []
    ////        biến tạm đang nill
    //        var currentSection: Section?
    //
    ////        Duyệt tất cả giao dịch
    //        for transaction in transactions {
    ////            lấy ngày của trasaction
    //            let date = Calendar.current.startOfDay(for: transaction.getCreateAt)
    //
    //            // Nếu biến tạm chưa tồn tại hoặc ngày của transaction khác với ngày của biến tạm
    //            if currentSection == nil || currentSection!.date != date {
    ////                gán tạo 1 Section mới vào biến tạm
    ////                Section này có ngày là ngày của giao dịch và mảng rõng
    //                currentSection = Section(date: date, transactions: [])
    //
    ////                Cộng vào biến sẽ return biến tạm này
    //                sections.append(currentSection!)
    //            }
    //
    //            // Thêm transaction vào section tương ứng
    //            currentSection?.transactions.append(transaction)
    //        }
    //
    //        return sections
    //    }
    
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
    ///Nạp tất cả transaction được truyền vào vào mảng transactions để đổ lên table view
    func setTransactions(data: [Transaction]) {
        
        for i in data{
            transactions.append(i)
        }
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
    
    
    @IBAction func btn_filter_tapped(_ sender: UIBarButtonItem) {
        view_filter.isHidden = !view_filter.isHidden
    }
    
    
    
}
extension TransactionViewController: UITableViewDataSource, UITableViewDelegate{
    //    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].transactions.count // Trả về số lượng giao dịch trong section đó
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        let transaction = sections[indexPath.section].transactions[indexPath.row]
        
        //Bỏ thông tin vào các UI của cell
        cell.transaction_name.text = transaction.getCategory.getName
        cell.transaction_img.image = transaction.getCategory.getImage
        cell.transaction_description.text = transaction.getDescription
        cell.transaction_balance.text = String(transaction.getBalance)
        cell.transaction_time.text = DateToString(transaction.getCreateAt)
        
        
        //        Nếu là thu nhập: Đổi màu chữ qua xanh
        if (transaction.getBalance > 0 && transaction.getCategory.getinCome){
            cell.transaction_balance.textColor = .green
        }
        else{
            cell.transaction_balance.textColor = .red
        }
        return cell
        
    }
    //    Hàm set title TODAY, YESTERDAY...
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: sections[section].date)
    }
    
    
    //  UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(transactions[indexPath.row])
        
        //        Chuyển màn hình
        //Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        Lấy màn hình cần chuyển qua
        let view_controller = storyboard.instantiateViewController(withIdentifier: "detail_transaction")
        //        set title cho navigation
        //        view_controller.navigationItem.title = transactions[indexPath.row]
        
        //        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
        navigationController?.pushViewController(view_controller, animated: true)
    }
}
