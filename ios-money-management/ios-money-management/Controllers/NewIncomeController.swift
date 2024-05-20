//
//  NewIncomeController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 09/02/1403 AP.
//

import UIKit
import PhotosUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class NewIncomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PHPickerViewControllerDelegate {
    
    
    //MARK: properties
    @IBOutlet weak var popupWalletButton: UIButton!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var txt_des: UITextField!
    @IBOutlet weak var popupCategoryButton: UIButton!
    @IBOutlet weak var collectionImagesView: UICollectionView!
    var selectedImages = [UIImage]()
    var wallets: [Wallet] = []
    var categoryID = ""
    var wallet:Wallet? = nil
    var UID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào NewIncomeController")
        //       Lấy UID
        UID = UserDefaults.standard.string(forKey: "UID") ?? ""
        //button custom
        setFrontEnd()
        
        //        Đổ category vào pop up category
        setCategoryExpenses()
        
        setWallets(wallets: wallets)
        
        setNavbar()
    }
    
    //MARK: set up data in popup button
    func setPopupCategoryButton() {
        //thay doi title moi khi chon
        let optionClosure = {(action: UIAction) in
            let attributedTitle = NSAttributedString(string: action.title)
            
            self.popupCategoryButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        //hien thi ra option
        popupCategoryButton.menu = UIMenu(children: [
            UIAction(title: "option 1", handler: optionClosure),
            UIAction(title: "option 2", handler: optionClosure),
            UIAction(title: "option 3", handler: optionClosure)
        ])
        popupCategoryButton.showsMenuAsPrimaryAction = true
        popupCategoryButton.changesSelectionAsPrimaryAction = true
    }
    
    func setPopupWalletButton(wallets:[Wallet]) {
        // Tạo các UIAction từ danh sách Wallet
        let actions = wallets.map { wallet in
            UIAction(title: wallet.getName, image: wallet.getImage) { [weak self] action in
                guard let self = self else { return } // Tránh strong reference cycle
                
                // Cập nhật giao diện của popup button (tùy chọn)
                self.popupWalletButton.setTitle(action.title, for: .normal)
                self.popupWalletButton.setImage(action.image, for: .normal)
                
                // Xử lý khi người dùng chọn một ví (tùy thuộc vào logic ứng dụng của bạn)
                print("Chọn ví: \(wallet.getName)")
            }
        }
        
        // Tạo UIMenu từ các UIAction
        let menu = UIMenu(children: actions)
        
        // Gán UIMenu cho popup button và hiển thị
        popupWalletButton.menu = menu
        popupWalletButton.showsMenuAsPrimaryAction = true
        
        //
        //        //thay doi title moi khi chon
        //        let optionClosure = {(action: UIAction) in
        //            let attributedTitle = NSAttributedString(string: action.title)
        //
        //            self.popupWalletButton.setAttributedTitle(attributedTitle, for: .normal)
        //        }
        //        //hien thi ra option
        //        popupWalletButton.menu = UIMenu(children: [
        //            UIAction(title: "option 1", handler: optionClosure),
        //            UIAction(title: "option 2", handler: optionClosure),
        //            UIAction(title: "option 3", handler: optionClosure)
        //        ])
        //        popupWalletButton.showsMenuAsPrimaryAction = true
        //        popupWalletButton.changesSelectionAsPrimaryAction = true
    }
    func setNavbar() {
        //set background for navigation controller
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255, green: 180/255, blue: 126/255, alpha: 1);
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    func setCategoryExpenses() {
//        lấy tab bar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
//            lấy danh sách income
            let category_income = tabBarController.category_income
            
//            Đổ dữ liệu vào pop up
            let actions = category_income.map { category in
                UIAction(title: category.getName, image: category.getImage) { [weak self] action in
                    guard let self = self else { return } // Tránh strong reference cycle
                    self.categoryID = category.getID
                    self.popupCategoryButton.setAttributedTitle(NSAttributedString(string: action.title), for: .normal)
                    self.popupCategoryButton.setImage(action.image, for: .normal)
                }
            }
//            set pop up
            popupCategoryButton.menu = UIMenu(children: actions)
            popupCategoryButton.showsMenuAsPrimaryAction = true
            
        }
//        Task {
//            let income = await Category.getIncome()
//
//            let actions = income.map { category in
//                UIAction(title: category.getName, image: category.getImage) { [weak self] action in
//                    guard let self = self else { return } // Tránh strong reference cycle
//                    self.categoryID = category.getID
//                    self.popupCategoryButton.setAttributedTitle(NSAttributedString(string: action.title), for: .normal)
//                    self.popupCategoryButton.setImage(action.image, for: .normal)
//                }
//            }
//
//            await MainActor.run {
//                popupCategoryButton.menu = UIMenu(children: actions)
//                popupCategoryButton.showsMenuAsPrimaryAction = true
//            }
//        }
    }
    func setWallets(wallets:[Wallet])  {
        // Tạo các UIAction từ danh sách Wallet
        let actions = wallets.map { wallet in
            UIAction(title: wallet.getName, image: wallet.getImage) { [weak self] action in
                guard let self = self else { return }
                
                // Cập nhật giao diện của popup button (tùy chọn)
                self.popupWalletButton.setAttributedTitle(NSAttributedString(string: wallet.getName), for: .normal)
                self.popupWalletButton.setImage(wallet.getImage, for: .normal) // Đặt lại ảnh
                self.wallet = wallet
                // Xử lý khi người dùng chọn một ví
                // Gọi hàm xử lý đã chọn ví (đã được khai báo ở đâu đó trong ViewController)
                //                    self.handleWalletSelection(wallet: wallet)
            }
        }
        
        // Tạo UIMenu từ các UIAction và gán cho popup button
        popupWalletButton.menu = UIMenu(children: actions)
        popupWalletButton.showsMenuAsPrimaryAction = true
    }
    //MARK: events
    
    @IBAction func addImagesTapped(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        let phVC = PHPickerViewController(configuration: config)
        phVC.delegate = self
        self.present(phVC, animated: true)
        
    }
    
    //MARK: implementing classes
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for r in results {
            r.itemProvider.loadObject(ofClass: UIImage.self) {(object,err) in
                if let img = object as? UIImage {
                    self.selectedImages.append(img)
                }
                DispatchQueue.main.sync {
                    self.collectionImagesView.reloadData()
                }
            }
        }
    }
    
    @IBAction func NewIncome_Tapped(_ sender: UIButton)  {
        if let balanceString = textFieldValue.text,
               let balance = Int(balanceString),
               let description = txt_des.text,
               let wallet = wallet
            {
                Task {
                    do {
                        
                        // Thêm giao dịch mới lên DB và lấy ID của nó
                        let transactionID = try await Transaction.addTransaction(
                            wallet_id: wallet.getID,
                            balance: balance,
                            category_id: categoryID,
                            des: description,
                            images: selectedImages
                        )

                        // Cập nhật số dư ví trên DB
                        Wallet.set_updateWallet(UID: UID, wallet: Wallet(ID: wallet.getID, Name: wallet.getName, Balance: wallet.Balance + balance, Transaction: wallet.getTransactions()))
                        

                        
                        
                        

                        // Thêm transaction mới tạo vào mảng transactions của ví ở
                        // Tạo transaction mới với ID vừa nhận được
                        let newTransaction = await Transaction(id: transactionID, description: description, balance: balance, category: Category.getCategory(Category_ID: categoryID)!, create_at: Date(), wallet_id: wallet.getID, imageUrls: [])
                        
                        if let tabBarController = self.tabBarController as? TabHomeViewController {
                            if let userProfile = tabBarController.userProfile {
                                if let wallet = userProfile.Wallets.first(where: {$0.getID == wallet.getID}) {
                                    // Thêm transaction vào wallet
                                    wallet.addTransaction(transaction: newTransaction)
                                
                                    //                        Cập nhật tiền của ví dưới local
                                    wallet.Balance = wallet.Balance + balance
                                    
                                }
                                
                            }
                        }

                    } catch {
                        // Xử lý lỗi nếu có
                        print("Error adding transaction: \(error)")
                    }
                    navigationController?.popViewController(animated: true)
                }
            } else {
                // Xử lý trường hợp UID hoặc walletID không tồn tại
                print("Error: UID or walletID is missing")
            }
        //        if let balanceString = textFieldValue.text,
//           let balance = Int(balanceString),
//           let description = txt_des.text,
//           let wallet = wallet
//        {
////            Gọi hàm tạo giao dịch
//            Transaction.addTransaction(
//                wallet_id: wallet.getID,
//                    balance: balance,
//                    category_id: categoryID,
//                    des: description)
//
////            Cộng tiền vào ví
//            Wallet.set_updateWallet(UID: UID, wallet: Wallet(ID: wallet.getID, Name: wallet.getName, Balance: wallet.getBalance + balance, Transaction: wallet.getTransactions()))
//
//// Apped transaction vào userProfile
////            Lấy tabbar
//            if let tabBarController = self.tabBarController as? TabHomeViewController {
//                    if let userProfile = tabBarController.userProfile {
//                        if let wallet = userProfile.getWallets.first(where: {$0.getID == wallet.getID}) {
//                            // Thêm transaction vào wallet
//                            wallet.addTransaction(transaction: Transaction(id: <#T##String#>, description: <#T##String#>, balance: <#T##Int#>, category: <#T##Category#>, create_at: <#T##Date#>, wallet_id: <#T##String#>) )
//                        }
//                    }
//                }
//
//
//        } else {
//            // Xử lý trường hợp UID hoặc walletID không tồn tại
//            print("Error: UID or walletID is missing")
//        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuse = "IncomeImageCell"
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? IncomeImageCell{
            cell.imgView.image = selectedImages[indexPath.row]
            
            //cancel button
            cell.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_ :)), for: .touchUpInside)
            cell.cancelButton.tag = indexPath.row
            
            return cell
        }
        
        fatalError("Khong the return Income ")
        
        
        
    }
    func setFrontEnd()  {
        // Thiết lập tiêu đề của nut
        let attributedTitleCategory = NSAttributedString(string: "Category")
        popupCategoryButton.setAttributedTitle(attributedTitleCategory, for: .normal)
        
        let attributedTitleWallet = NSAttributedString(string: "Wallet")
        popupWalletButton.setAttributedTitle(attributedTitleWallet, for: .normal)
        //chinh mau chu cho textfield $0
        textFieldValue.attributedPlaceholder = NSAttributedString(string: "$0",attributes: [.foregroundColor: UIColor.white])
        
        // Thiết lập các thuộc tính cho các nút khác
        popupCategoryButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
        popupCategoryButton.layer.borderWidth = 1
        popupCategoryButton.layer.cornerRadius = 6
        popupWalletButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
        popupWalletButton.layer.borderWidth = 1
        popupWalletButton.layer.cornerRadius = 6
        
        //        Đổ category vào pop up
        //        self.setPopupCategoryButton()
        
        //        Đổ wallets vào pop up
        //        self.setPopupWalletButton()
        
        
        //        Xoá navigation bottom
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        selectedImages.remove(at: sender.tag)
        collectionImagesView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImagesView.frame.size.width/3 - 10, height: 128 - 10)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     @IBAction func popupWalletButton(_ sender: UIButton) {
     }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
