//
//  NewIncomeController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 09/02/1403 AP.
//

import UIKit
import PhotosUI

class NewIncomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PHPickerViewControllerDelegate {
   
    
    //MARK: properties
    @IBOutlet weak var popupWalletButton: UIButton!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var popupCategoryButton: UIButton!
    @IBOutlet weak var collectionImagesView: UICollectionView!
    var selectedImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vào NewIncomeController")
        //button custom
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
        self.setPopupCategoryButton()
        self.setPopupWalletButton()
        
        
//        Xoá navigation bottom
        self.tabBarController?.tabBar.isHidden = true

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
