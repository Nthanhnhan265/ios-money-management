//
// HomeViewController.swift
// ios-money-management
//
// Created by AnNguyen on 23/04/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class HomeViewController: UIViewController {
    //    Cấu trúc filter Ví và Thời gian
    struct FilterState {
        var selectedWallet: Wallet?
        var buttonTime:UIButton?
        
    }
    
    //    MARK: Dữ liệu
    var transactions = [Transaction]()
    var wallets = [Wallet]()
    var currentFilterState = FilterState()
    
    // MARK: @IBOutlet
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var txt_balance: UILabel!
    @IBOutlet weak var borderAvatar: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btn_week: UIButton!
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_year: UIButton!
    @IBOutlet weak var btn_month: UIButton!
    @IBOutlet weak var btn_Expenses: UIButton!
    @IBOutlet weak var btn_income: UIButton!
    @IBOutlet weak var menu_wallets: UIButton!
    
    
    
    
    // MARK: Firestore
    // Tạo một tham chiếu đến cơ sở dữ liệu Firestore
    private let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lấy UID
        let UID = UserDefaults.standard.string(forKey: "UID") ?? ""
        
        // Set thiết kế giao diện
        setFrontEnd()
        
        
        // Kết nối table view với các hàm để load dữ liệu
        table_view.dataSource = self
        table_view.delegate = self
        table_view.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)

        
        
        //debug
        print("Vào HomeViewController - \(UID)")
        
        //        Lấy userProfile đang nằm trong Tabbar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
            // Truy cập dữ liệu trong TabBarController
            if let userProfile = tabBarController.userProfile
            {
                setProfile(userProfile: userProfile)
                txt_balance.text = String(setWallets(wallets: userProfile.getWallets ).getVNDFormat())
                //                             Set transactions
                for wallet in userProfile.getWallets{
                    setTransactions(data: wallet.getTransactions)
                    
//                    Lấy dữ liệu của userProfile, đọc tất cả các ví -> Đổi vào mảng dữ liệu
                    self.wallets.append(wallet)
                    
                }
                transactions.sort { $0.getCreateAt > $1.getCreateAt }

            }
            
        }
         
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Load lại HomeViewController")
        // Set lại màu cho nav
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        
    }
    /// Hàm chuyển đồ từ Date sang String
    func DateToString(_ date:Date) -> String{
        // Lấy ra 1 biến Date ở thời gian hiện tại
        let currentDateAndTime = date
        // Tạo ra 1 biến format
        let dateFormatter = DateFormatter()
        
        // Ngày: 5/9/24
        dateFormatter.dateStyle = .short
        
        // Giờ none
        dateFormatter.timeStyle = .none
        
        // Địa điểm
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        //09/05/2024
        // print(dateFormatter.string(from: currentDateAndTime))
        // Date -> String
        // print(type(of: dateFormatter.string(from: currentDateAndTime)))
        
        
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
    // MARK: Func set dữ liệu giả
    func setFrontEnd() {
        //custom avatar va border
        avatar.layer.cornerRadius = avatar.frame.height/2
        
        borderAvatar.layer.borderWidth = 2
        borderAvatar.layer.masksToBounds = true
        borderAvatar.layer.borderColor = CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1)
        borderAvatar.layer.cornerRadius = borderAvatar.frame.height/2
    }
/// Set ảnh đại diện
    func setProfile(userProfile:UserProfile) {
        
        
        // set avatar
        avatar.image = userProfile.getAvatar
        
        
        
    }
    ///Nạp tất cả transaction được truyền vào vào mảng transactions để đổ lên table view
    func setTransactions(data: [Transaction]) {
        
        for i in data{
            transactions.append(i)
        }
    }
    ///Đổ ví vào pop up, đồng thời trả ra total_balance
    func setWallets(wallets: [Wallet]) -> Int{
        // Tổng tiền
        var total_balance = 0
        
        //        Cộng tổng tiền của các ví
        for i in wallets{
            total_balance += i.getBalance
        }
        
        
        let optionClosure = {
            // Sử dụng weak self để tránh retain cycle (vòng lặp giữ tham chiếu mạnh), đảm bảo HomeViewController không bị giữ lại trong bộ nhớ khi không cần thiết.
            [weak self] (action: UIAction) in
            
            // Tìm ví được chọn dựa trên title của UIAction
            // Tìm ví có tên trùng với action.title.
            guard let selectedWallet = wallets.first(where: { $0.getName == action.title})
                    
                    
                    // Nếu không tìm thấy:
            else {
                // (hoặc người dùng chọn "Tổng cộng")
                if action.title == "Tổng cộng" {
                    
                    self!.txt_balance.text = String(total_balance.getVNDFormat())
                    //                    Set lại ví đang chọn là nil
                    self?.currentFilterState.selectedWallet = nil
                    // Gọi hàm cập nhật giao dịch
                    self?.updateTransactions()
                    // sẽ thực hiện các xử lý trong khối else.
                } else {
                    
                    // Xử lý trường hợp không tìm thấy ví
                    print("Không tìm thấy ví")
                }
                return
            }
            
            // Cập nhật txt_balance.text
            self?.txt_balance.text = String(selectedWallet.getBalance.getVNDFormat())
            
            // Bạn có thể thực hiện thêm các hành động khác ở đây (ví dụ: cập nhật giao diện)
            
            // Cập nhật trạng thái bộ lọc
            self?.currentFilterState.selectedWallet = selectedWallet
            
            // Gọi hàm cập nhật giao dịch
            self?.updateTransactions()
            
        }
        
        
        // Tạo các UIAction từ wallets
        let walletActions = wallets.map { wallet in
            UIAction(title: wallet.getName, image: wallet.getImage, handler: optionClosure)
        }
        
        
        
        
        
        menu_wallets.menu = UIMenu(children: [
            UIAction(title: "Tổng cộng", state: .on, handler: optionClosure),] + walletActions)
        
        
        return total_balance
    }
    func updateTransactions() {
        //        Làm rỗng mảng chứa danh sách giao dịch
        self.transactions = []
        
        //        Nếu có ví được chọn
        if (currentFilterState.selectedWallet != nil){
            //            Lấy transaction của ví hiện tại được chọn
            setTransactions(data: currentFilterState.selectedWallet!.getTransactions)
        }
        //        Nếu không có ví được chọn: Lấy tất cả giao dịch của các ví
        else{
            
            for i in wallets{
                setTransactions(data: i.getTransactions)
            }
            
        }
        
        //        nếu có sự lựa chọn về thời gian
        if let btn_time =  currentFilterState.buttonTime{
            switch btn_time{
            case btn_today:
                // Lấy ngày hiện tại
                let currentDate = Date()
                
                // Tính toán ngày 7 ngày trước
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
                
                // Lọc các giao dịch
                let filteredTransactions = transactions.filter { transaction in
                    return sevenDaysAgo <= transaction.getCreateAt && transaction.getCreateAt <= currentDate
                }
                transactions = filteredTransactions
            case btn_month:
                // Lấy ngày hiện tại
                let currentDate = Date()
                
                // Tính toán ngày 7 ngày trước
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!
                
                // Lọc các giao dịch
                let filteredTransactions = transactions.filter { transaction in
                    return sevenDaysAgo <= transaction.getCreateAt && transaction.getCreateAt <= currentDate
                }
                transactions = filteredTransactions
            case btn_week:
                // Lấy ngày hiện tại
                let currentDate = Date()
                
                // Tính toán ngày 7 ngày trước
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
                
                // Lọc các giao dịch
                let filteredTransactions = transactions.filter { transaction in
                    return sevenDaysAgo <= transaction.getCreateAt && transaction.getCreateAt <= currentDate
                }
                transactions = filteredTransactions
            case btn_year:
                // Lấy ngày hiện tại
                let currentDate = Date()
                
                // Tính toán ngày 7 ngày trước
                let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -365, to: currentDate)!
                
                // Lọc các giao dịch
                let filteredTransactions = transactions.filter { transaction in
                    return sevenDaysAgo <= transaction.getCreateAt && transaction.getCreateAt <= currentDate
                }
                transactions = filteredTransactions
            default:
                print("Lỗi filter theo button time")
            }
            
        }
        transactions.sort { $0.getCreateAt > $1.getCreateAt }
        
        table_view.reloadData()
    }
    // MARK: @IBAction
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
        // Task {
        // if let userProfile = await UserProfile.getUserProfine(UID: UserDefaults.standard.string(forKey: "UID") ?? "") {
        // viewController.wallets = userProfile.getWallets
        //
        //
        // // Chuyển màn hình sau khi đã có dữ liệu và trên main thread
        // await MainActor.run {
        // navigationController?.pushViewController(viewController, animated: true)
        // }
        // }
        // }
        //----
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let view_controller = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        //
        //
        // view_controller.navigationItem.title = "Income"
        // navigationController?.pushViewController(view_controller, animated: true)
        
        
        //-----
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let viewController = storyboard.instantiateViewController(withIdentifier: "Income") as! NewIncomeController
        //
        // // Lấy danh sách wallets từ UserProfile hoặc nguồn dữ liệu khác
        // Task {
        // if let userProfile = await UserProfile.getUserProfine(UID: UserDefaults.standard.string(forKey: "userId") ?? "") {
        // viewController.wallets = userProfile.getWallets
        // viewController.test = "123123"
        //
        //
        // }
        // }
        //
        // viewController.navigationItem.title = "Income"
        // navigationController?.pushViewController(viewController, animated: true)
    }
    // click btn week
    @IBAction func btn_week_click(_ sender: UIButton) {
        //Kiểm tra xem button đang được click có phải là button đang active không
        if currentFilterState.buttonTime == sender {
            //            thực hiện các bước sau để hủy active
            currentFilterState.buttonTime?.layer.cornerRadius = 0
            currentFilterState.buttonTime?.clipsToBounds = false
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            
            // Đặt lại buttonTime về nil, biểu thị không có button nào đang active.
            currentFilterState.buttonTime = nil
        }
        //        Click button khác
        else {
            //Kiểm tra xem có button nào khác đang active không. Nếu có, hủy active button đó.
            if currentFilterState.buttonTime != nil {
                currentFilterState.buttonTime?.layer.cornerRadius = 0
                currentFilterState.buttonTime?.clipsToBounds = false
                currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            }
            //Đặt các thuộc tính giao diện của button mới thành trạng thái active.
            
            currentFilterState.buttonTime = sender
            currentFilterState.buttonTime?.layer.cornerRadius = 20
            currentFilterState.buttonTime?.clipsToBounds = true
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        }
        updateTransactions()
    }
    @IBAction func btn_seeAll_tapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1 // Chuyển sang tab thứ 2 (index bắt đầu từ 0)
        
    }
    // click btn today
    @IBAction func btn_today_clik(_ sender: UIButton) {
        //Kiểm tra xem button đang được click có phải là button đang active không
        if currentFilterState.buttonTime == sender {
            //            thực hiện các bước sau để hủy active
            currentFilterState.buttonTime?.layer.cornerRadius = 0
            currentFilterState.buttonTime?.clipsToBounds = false
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            
            // Đặt lại buttonTime về nil, biểu thị không có button nào đang active.
            currentFilterState.buttonTime = nil
        }
        //        Click button khác
        else {
            //Kiểm tra xem có button nào khác đang active không. Nếu có, hủy active button đó.
            if currentFilterState.buttonTime != nil {
                currentFilterState.buttonTime?.layer.cornerRadius = 0
                currentFilterState.buttonTime?.clipsToBounds = false
                currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            }
            //Đặt các thuộc tính giao diện của button mới thành trạng thái active.
            
            currentFilterState.buttonTime = sender
            currentFilterState.buttonTime?.layer.cornerRadius = 20
            currentFilterState.buttonTime?.clipsToBounds = true
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        }
        updateTransactions()
    }
    // click btn month
    @IBAction func btn_month_click(_ sender: UIButton) {
        //Kiểm tra xem button đang được click có phải là button đang active không
        if currentFilterState.buttonTime == sender {
            //            thực hiện các bước sau để hủy active
            currentFilterState.buttonTime?.layer.cornerRadius = 0
            currentFilterState.buttonTime?.clipsToBounds = false
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            
            // Đặt lại buttonTime về nil, biểu thị không có button nào đang active.
            currentFilterState.buttonTime = nil
        }
        //        Click button khác
        else {
            //Kiểm tra xem có button nào khác đang active không. Nếu có, hủy active button đó.
            if currentFilterState.buttonTime != nil {
                currentFilterState.buttonTime?.layer.cornerRadius = 0
                currentFilterState.buttonTime?.clipsToBounds = false
                currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            }
            //Đặt các thuộc tính giao diện của button mới thành trạng thái active.
            
            currentFilterState.buttonTime = sender
            currentFilterState.buttonTime?.layer.cornerRadius = 20
            currentFilterState.buttonTime?.clipsToBounds = true
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        }
        updateTransactions()
    }
    // click btn year
    @IBAction func btn_year_click(_ sender: UIButton) {
        //Kiểm tra xem button đang được click có phải là button đang active không
        if currentFilterState.buttonTime == sender {
            //            thực hiện các bước sau để hủy active
            currentFilterState.buttonTime?.layer.cornerRadius = 0
            currentFilterState.buttonTime?.clipsToBounds = false
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            
            // Đặt lại buttonTime về nil, biểu thị không có button nào đang active.
            currentFilterState.buttonTime = nil
        }
        //        Click button khác
        else {
            //Kiểm tra xem có button nào khác đang active không. Nếu có, hủy active button đó.
            if currentFilterState.buttonTime != nil {
                currentFilterState.buttonTime?.layer.cornerRadius = 0
                currentFilterState.buttonTime?.clipsToBounds = false
                currentFilterState.buttonTime?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
            }
            //Đặt các thuộc tính giao diện của button mới thành trạng thái active.
            
            currentFilterState.buttonTime = sender
            currentFilterState.buttonTime?.layer.cornerRadius = 20
            currentFilterState.buttonTime?.clipsToBounds = true
            currentFilterState.buttonTime?.backgroundColor = UIColor(red: 252/255, green: 238/255, blue: 212/255, alpha: 1.0)
            currentFilterState.buttonTime?.setTitleColor(UIColor(red: 252/255, green: 172/255, blue: 18/255, alpha: 1.0), for: .normal)
        }
        updateTransactions()
    }
    
}


extension HomeViewController: UITableViewDataSource,  UITableViewDelegate{
    // MARK:     UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    //    Đổ dữ liệu vào cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        
        
        // Đổ dữ liệu lên cell
        cell.transaction_img.image = self.transactions[indexPath.row].getCategory.getImage
        cell.transaction_name.text = self.transactions[indexPath.row].getCategory.getName
        cell.transaction_balance.text = String(self.transactions[indexPath.row].getBalance.getVNDFormat())
        cell.transaction_time.text = DateToString(self.transactions[indexPath.row].getCreateAt)
        cell.transaction_description.text = self.transactions[indexPath.row].getDescription
        
        //        Nếu là thu nhập: Đổi màu chữ qua xanh
        if (self.transactions[indexPath.row].getBalance > 0 && self.transactions[indexPath.row].getCategory.getinCome){
            cell.transaction_balance.textColor = .green
        }
        else{
            cell.transaction_balance.textColor = .red
        }
        return cell
        
        
        
        
        
        
    }
    
    // MARK: UITableViewDelegate
    // làm 1 hành động nào đó khi click vào 1 đối tượng
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Hàng thứ: " + String(indexPath.row))
        
        
        //Lấy main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //        Màn hình màu xanh
        if (transactions[indexPath.row].getCategory.getinCome){
//            Lấy màn hình
            let detail_Income_ViewController = storyboard.instantiateViewController(withIdentifier: "detail_transaction_Income") as! DetailIncomeViewController
            //        set title cho navigation
            detail_Income_ViewController.navigationItem.title = "Detail Income Transaction"
            
            // Đổ dữ liệu qua màn hình
            detail_Income_ViewController.transaction = transactions[indexPath.row]
           
            
            // Đẩy màn hình vào hàng đợi... (chuyển màn hình)
            navigationController?.pushViewController(detail_Income_ViewController, animated: true)
            
        }
//        Màn hình màu đỏ
        else{
            let detail_Expense_ViewController = storyboard.instantiateViewController(withIdentifier: "detail_transaction_Expenses") as! DetailExpenseViewController
            detail_Expense_ViewController.navigationItem.title = "Detail Expenses Transaction"
            // Lấy màn hình cần chuyển qua
            detail_Expense_ViewController.transaction = transactions[indexPath.row]
            // Đẩy màn hình vào hàng đợi... (chuyển màn hình)
            navigationController?.pushViewController(detail_Expense_ViewController, animated: true)
            
        }

       
        
        
        
        
        
        
    }
    
}

extension Int {
    func getVNDFormat()->String {
        let balance = self
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .currency
        if let formatterBalance = formatter.string(from: NSNumber(value: balance))
        {
            return formatterBalance;
        }
        return "-1";
    }
}

