//
//  HomeViewController.swift
//  ios-money-management
//
//  Created by AnNguyen on 23/04/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    //    MARK: Dữ liệu giả
    var transactions = [Transaction]()
    
    //    MARK: @IBOutlet
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var txt_balance: UILabel!
    @IBOutlet weak var borderAvatar: UIView!
    @IBOutlet weak var avatar: UIImageView!
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
    var wallets = [Wallet]()
    
    //    MARK: Firestore
    //        Tạo một tham chiếu đến cơ sở dữ liệu Firestore
    private let db = Firestore.firestore()
    
    
    override func viewDidLoad()      {
        super.viewDidLoad()
        
        //       Lấy UID
        let UID = UserDefaults.standard.string(forKey: "UID") ?? ""
        
        //        Set thiết kế giao diện
        setFrontEnd()
        
        //        Kết nối table view với các hàm để load dữ liệu
        table_view.dataSource = self
        table_view.delegate = self
        table_view.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        
        
        //debug
        print("Vào HomeViewController - \(UID)")
        
        
        
      
        
        
        
        
        
        
        
        
        
        
        Task{
            if let userProfile = await UserProfile.getUserProfine(UID: UID){
                setProfile(userProfile: userProfile)
                txt_balance.text =  String(setWallets(wallets: userProfile.getWallets ))
                
                
                //                Set transactions
                for wallet in userProfile.getWallets{
                    setTransactions(data: wallet.getTransactions)
                    self.wallets.append(wallet)
                    
                }
                // Reload table view on main thread
                await MainActor.run {
                    table_view.reloadData()
                }
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
                
                homeViewController.datas  = self.transactions
                
            }
          
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Load lại HomeViewController")
        //        Set lại màu cho nav
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        
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
    //    MARK: Func set dữ liệu giả
    func setFrontEnd() {
        //custom avatar va border
        avatar.layer.cornerRadius = avatar.frame.height/2
        
        borderAvatar.layer.borderWidth = 2
        borderAvatar.layer.masksToBounds = true
        borderAvatar.layer.borderColor = CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1)
        borderAvatar.layer.cornerRadius = borderAvatar.frame.height/2
        
        
        
        //        Set mặc định button Today được active
        btn_today.layer.cornerRadius = 20
        btn_today.clipsToBounds = true
        btn_today.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
        btn_today.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        activeButton = btn_today
        
    }
    func setProfile(userProfile:UserProfile)   {
        
        
        //            set avatar
        avatar.image = userProfile.getAvatar
        
        
        
    }
    func setTransactions(data: [Transaction]) {
        for i in data{
            transactions.append(i)
        }
        //        for i in 10..<30{
        //            if let time = StringToDate("\(i)/05/2024"){
        //                datas.append()
        //            }
        //        }
        
        
        
    }
    func setWallets(wallets: [Wallet]) -> Int{
        var total_balance =  0
        for i in wallets{
            total_balance += i.getBalance
        }
        
        //        let optionClosure = { (action: UIAction) in
        //            print(action.title)
        //
        //        }
        let optionClosure = {
            [weak self] (action: UIAction) in
            // [weak self] để tránh retain cycle
            
            // Tìm ví được chọn dựa trên title của UIAction
            guard let selectedWallet = wallets.first(where: { $0.getName == action.title }) else {
                if action.title == "Tổng cộng" {
                    self!.txt_balance.text = String(total_balance)
                } else {
                    // Xử lý trường hợp không tìm thấy ví
                    print("Không tìm thấy ví")
                }
                return
            }
            
            // Cập nhật txt_balance.text
            self?.txt_balance.text = String(selectedWallet.getBalance)
            
            // Bạn có thể thực hiện thêm các hành động khác ở đây (ví dụ: cập nhật giao diện)
        }
        //        menu_wallets.menu = UIMenu(children: [
        //            UIAction(title: "Tổng cộng", state: .on, handler: optionClosure)
        //            UIAction(title: "Tiền mặt", handler: optionClosure)
        //
        //        ])
        
        // Tạo các UIAction từ wallets
        let walletActions = wallets.map { wallet in
            UIAction(title: wallet.getName, image: wallet.getImage,  handler: optionClosure)
        }
        
        
        //        menu_wallets.menu = UIMenu(children: [
        //            UIAction(title: "Tổng cộng", state: .on, handler: optionClosure)
        //        ] + walletActions) // Nối mảng walletActions vào mảng children
        
        
        menu_wallets.menu = UIMenu(children: [
            UIAction(title: "Tổng cộng", state: .on, handler: optionClosure),
            // ... (phần còn lại của children giữ nguyên)
        ] + walletActions)
        
        
        return total_balance
    }
    
    //    MARK: @IBAction
    @IBAction func btn_expenses(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view_controller = storyboard.instantiateViewController(withIdentifier: "Expense") as! NewExpenseController
        view_controller.navigationItem.title = "Expense"
        view_controller.wallets = wallets
        navigationController?.pushViewController(view_controller, animated: true)
        
       
      
        
        
    }
    @IBAction func btn_income_click(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        viewController.wallets = wallets
        navigationController?.pushViewController(viewController, animated: true)
        
        
        
        //----
//        Task {
//            if let userProfile = await UserProfile.getUserProfine(UID: UserDefaults.standard.string(forKey: "UID") ?? "") {
//                viewController.wallets = userProfile.getWallets
//
//
//                // Chuyển màn hình sau khi đã có dữ liệu và trên main thread
//                await MainActor.run {
//                    navigationController?.pushViewController(viewController, animated: true)
//                }
//            }
//        }
        //----
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let view_controller = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        //
        //
        //        view_controller.navigationItem.title = "Income"
        //        navigationController?.pushViewController(view_controller, animated: true)
        
        
        //-----
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let viewController = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        //
        //            // Lấy danh sách wallets từ UserProfile hoặc nguồn dữ liệu khác
        //            Task {
        //                if let userProfile =  await UserProfile.getUserProfine(UID: UserDefaults.standard.string(forKey: "userId") ?? "") {
        //                    viewController.wallets = userProfile.getWallets
        //                    viewController.test = "123123"
        //
        //
        //                }
        //            }
        //
        //            viewController.navigationItem.title = "Income"
        //            navigationController?.pushViewController(viewController, animated: true)
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
    
    //    MARK: Querry Database Firestore
    //    func getWallets(UID: String, completion: @escaping (UserProfile?) -> Void) {
    //        let ProfileRef = db.collection("Profile").document(UID)
    //
    //        ProfileRef.getDocument { (document, error) in
    //            if let document = document, document.exists {
    //                let data = document.data()
    //
    //                let userProfile = UserProfile(
    //                    UID: UID,
    //                    Fullname: data?["Fullname"] as? String ?? "",
    //                    Avatar: UIImage(named: data?["Avatar"] as? String ?? "")
    //                )
    //
    //                completion(userProfile) // Truyền UserProfile đến completion handler
    //            } else {
    //                completion(nil) // Truyền nil nếu có lỗi hoặc không có tài liệu
    //            }
    //        }
    //    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK:     UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell

        
//        Đổ dữ liệu lên cell
        cell.transaction_img.image = self.transactions[indexPath.row].getCategory.getImage
        cell.transaction_name.text = self.transactions[indexPath.row].getCategory.getName
        cell.transaction_balance.text = String(self.transactions[indexPath.row].getBalance)
        cell.transaction_time.text = DateToString(self.transactions[indexPath.row].getCreateAt)
        cell.transaction_description.text = self.transactions[indexPath.row].getDescription
        
        
       
        
        

        
 
        return cell
    }
    
    //   MARK: UITableViewDelegate
    //    làm 1 hành động nào đó khi click vào 1 đối tượng
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print("Nội dung: ", String(datas[indexPath.row].transactionName))
        print("Hàng thứ: " + String(indexPath.row))
        
        //Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        Lấy màn hình cần chuyển qua
        let view_controller = storyboard.instantiateViewController(withIdentifier: "detail_transaction_Expenses")
        //        set title cho navigation
        //        view_controller.navigationItem.title = datas[indexPath.row].transactionName
        //        Đẩy màn hình vào hàng đợi... (chuyển màn hình)
        navigationController?.pushViewController(view_controller, animated: true)
        //        self.present(view_controller, animated: true)
        
    }
    
}
