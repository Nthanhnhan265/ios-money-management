//
//  NewExpenseController.swift
//  ios-money-management
//
//  Created by anguyenthanhnhan on 08/02/1403 AP.
//

import UIKit
import PhotosUI

class NewExpenseController: UIViewController {
    
    //tham chieu den CollectionView
    @IBOutlet weak var collectionImagesView: UICollectionView!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var popupCategoryButton: UIButton!
    @IBOutlet weak var popupWalletButton: UIButton!
    @IBOutlet weak var textFieldDes: UITextField!
    var selectedImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()

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
               
               addImageButton.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1).cgColor
               addImageButton.layer.borderWidth = 1
               addImageButton.layer.cornerRadius = 16
  
        self.setPopupCategoryButton()
        self.setPopupWalletButton()
        
        //        Xoá navigation bottom
                self.tabBarController?.tabBar.isHidden = true

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
    
    func setPopupWalletButton() {
        //thay doi title moi khi chon
        let optionClosure = {(action: UIAction) in
            let attributedTitle = NSAttributedString(string: action.title)
         
            self.popupWalletButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        //hien thi ra option
        popupWalletButton.menu = UIMenu(children: [
            UIAction(title: "option 1", handler: optionClosure),
            UIAction(title: "option 2", handler: optionClosure),
            UIAction(title: "option 3", handler: optionClosure)
        ])
        popupWalletButton.showsMenuAsPrimaryAction = true
        popupWalletButton.changesSelectionAsPrimaryAction = true
    }
    @IBAction func addImageTapped(_ sender: UIButton) {
        //oject chua thong tin ve cau hinh cua PHPickerViewController
        var phconfig = PHPickerConfiguration()
        phconfig.selectionLimit = 5
        
        let phPickerVC = PHPickerViewController(configuration: phconfig)
        phPickerVC.delegate = self
        self.present(phPickerVC,animated: true)
        
    }
    
    
// Handle cancel button tap
    @objc func cancelButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedImages.remove(at: index)
        collectionImagesView.reloadData()
    }


 

}
extension NewExpenseController: PHPickerViewControllerDelegate{
    
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
}
extension NewExpenseController: UICollectionViewDataSource {
     
    //implement cac phuon thuc cho UICollecitonView
    //phuong thuc tra ve so luong
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        print(cell)
        cell.imageView.image = selectedImages[indexPath.row]
//        cell.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_ :)), for: .touchUpInside)
            return cell
    }
   
}
