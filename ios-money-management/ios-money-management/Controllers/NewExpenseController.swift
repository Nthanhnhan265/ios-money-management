//
//  NewExpenseController.swift
//  ios-money-management
//
//  Created by anguyenthanhnhan on 08/02/1403 AP.
//

import UIKit
import PhotosUI

class NewExpenseController: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    //MARK: Properties
    //tham chieu den CollectionView
    @IBOutlet weak var collectionImagesView: UICollectionView!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var popupCategoryButton: UIButton!
    @IBOutlet weak var popupWalletButton: UIButton!
    @IBOutlet weak var textFieldDes: UITextField!
    
    var selectedImages = [UIImage]()
    var wallets: [Wallet] = []
    var categoryID = ""
    var wallet:Wallet? = nil
    var UID = ""
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        //       Lấy UID
        UID = UserDefaults.standard.string(forKey: "UID") ?? ""

        setFrontEnd()
        
        //        Đổ category vào pop up category
        setCategoryExpenses()
        

        setWallets(wallets: wallets)

    }
    
    //MARK: setup button
    func setFrontEnd(){
        //set title cho navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //button custom
        // Thiết lập tiêu đề của nut
              let attributedTitleCategory = NSAttributedString(string: "Category")
              popupCategoryButton.setAttributedTitle(attributedTitleCategory, for: .normal)
        
        let attributedTitleWallet = NSAttributedString(string: "Wallet")
        popupWalletButton.setAttributedTitle(attributedTitleWallet, for: .normal)
        //chinh mau chu cho textfield $0
        textFieldValue.attributedPlaceholder = NSAttributedString(string: "$0",attributes: [.foregroundColor: UIColor.white])
        
        // Thiết lập các thuộc tính cho các nút khác
                textFieldDes.layer.cornerRadius = 16
//                textFieldDes.layer.masksToBounds = true
        
               popupCategoryButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               popupCategoryButton.layer.borderWidth = 1
               popupCategoryButton.layer.cornerRadius = 16
               
               popupWalletButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               popupWalletButton.layer.borderWidth = 1
               popupWalletButton.layer.cornerRadius = 16
               
              
        setNavbar()
        self.setPopupCategoryButton()
        self.setPopupWalletButton()
        
        //        Xoá navigation bottom
                self.tabBarController?.tabBar.isHidden = true
    }
    func setNavbar() {
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 255/255, green: 86/255, blue: 92/255, alpha: 1);
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
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
    
    @IBAction func btn_expenses_tapped(_ sender: UIButton) {
        if let balanceString = textFieldValue.text,
               let balance = Int(balanceString),
               let description = textFieldDes.text,
               let wallet = wallet
            {
                Task {
                    do {
                        // Thêm giao dịch mới lên DB và lấy ID của nó
                        let transactionID = try await Transaction.addTransaction(
                            wallet_id: wallet.getID,
                            balance: balance > 0 ? -balance : balance,
                            category_id: categoryID,
                            des: description,
                            images: []
                        )

                        // Cập nhật ví trên DB
                        Wallet.set_updateWallet(UID: UID, wallet: Wallet(ID: wallet.getID, Name: wallet.getName, Balance: wallet.Balance + (balance > 0 ? -balance : balance), Transaction: wallet.getTransactions()))
                        

                        
                        
                        

                        // Thêm transaction vào mảng transactions của ví
                        let newTransaction = await Transaction(id: transactionID, description: description, balance: balance > 0 ? -balance : balance, category: Category.getCategory(Category_ID: categoryID)!, create_at: Date(), wallet_id: wallet.getID, imageUrls: []) // Tạo transaction mới với ID vừa nhận được
                        
                        if let tabBarController = self.tabBarController as? TabHomeViewController {
                            if let userProfile = tabBarController.userProfile {
                                if let wallet = userProfile.getWallets.first(where: {$0.getID == wallet.getID}) {
                                    // Thêm transaction vào wallet
                                    wallet.addTransaction(transaction: newTransaction)
                                
                                    //                        Cập nhật tiền của ví dưới local
                                    wallet.Balance = wallet.Balance + (balance > 0 ? -balance : balance)
                                    
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
//           let description = textFieldDes.text,
//           let wallet = wallet
//        {
////            Gọi hàm tạo giao dịch
//            Transaction.addTransaction(
//                wallet_id: wallet.getID,
//                    balance: balance > 0 ? -balance : balance,
//                    category_id: categoryID,
//                    des: description)
//
//            //            Trừ tiền khỏi ví
//                        Wallet.set_updateWallet(UID: UID, wallet: Wallet(ID: wallet.getID, Name: wallet.getName, Balance: wallet.getBalance + (balance > 0 ? -balance : balance), Transaction: wallet.getTransactions()))
//
//
//        } else {
//            // Xử lý trường hợp UID hoặc walletID không tồn tại
//            print("Error: UID or walletID is missing")
//        }
    }
    func setPopupWalletButton() {
        //thay doi title moi khi chon
        let optionClosure = {(action: UIAction) in
            let attributedTitle = NSAttributedString(string: action.title)
         
            self.popupWalletButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        //hien thi ra optionr
        popupWalletButton.menu = UIMenu(children: [
            UIAction(title: "option 1", handler: optionClosure),
            UIAction(title: "option 2", handler: optionClosure),
            UIAction(title: "option 3", handler: optionClosure)
        ])
        popupWalletButton.showsMenuAsPrimaryAction = true
        popupWalletButton.changesSelectionAsPrimaryAction = true
    }
    func setWallets(wallets:[Wallet])  {
        // Tạo các UIAction từ danh sách Wallet
        let actions = wallets.map { wallet in
            UIAction(title: wallet.getName, image: wallet.getImage) { [weak self] action in
                guard let self = self else { return }
                
                // Cập nhật giao diện của popup button (tùy chọn)
                self.popupWalletButton.setAttributedTitle(NSAttributedString(string: wallet.getName), for: .normal)
                self.popupCategoryButton.setImage(wallet.getImage, for: .normal) // Đặt lại ảnh
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
    func setCategoryExpenses() {
        //        lấy tab bar controller
        if let tabBarController = self.tabBarController as? TabHomeViewController {
            //            lấy danh sách income
            let category_income = tabBarController.category_expenses
            
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
    }
    //MARK: event
    @IBAction func addImageTapped(_ sender: Any) {
        //oject chua thong tin ve cau hinh cua PHPickerViewController
        var phconfig = PHPickerConfiguration()
        phconfig.selectionLimit = 5
        
        let phPickerVC = PHPickerViewController(configuration: phconfig)
        phPickerVC.delegate = self
        self.present(phPickerVC,animated: true)
    }
    


    //MARK: implement classes
    //sau khi chon xong anh thi thuc hien hanh dong tai day
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        //duyet vong lap hinh anh da chon
    
        for r in results {
            r.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    self.selectedImages.append(image)
                    print("Image appended: \(image) \(self.selectedImages.count)")
                  
                }
                DispatchQueue.main.async {
                    self.collectionImagesView.reloadData()
                    print("Count after appending: \(self.selectedImages.count)")
                }
               
            }
        }
    }
    
    //phuong thuc tra ve so luong
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    //tai su dung ImageCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuse = "ImageCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? ImageCell {
            //image
            cell.imgView.image = selectedImages[indexPath.row]

            //cancel button
            cell.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_ :)), for: .touchUpInside)
            cell.cancelButton.tag = indexPath.row
            
            return cell
        }
        fatalError("khong the return");
    }
    
    // Handle cancel button tap
        @objc func cancelButtonTapped(_ sender: UIButton) {
            selectedImages.remove(at: sender.tag)
            collectionImagesView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 10 , height: 128 - 10)
    }
   
   
    

}

