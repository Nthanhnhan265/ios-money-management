//
//  AddWalletViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 19/02/1403 AP.
//

import UIKit
import FirebaseFirestore

class AddWalletViewController: UIViewController, UICollectionViewDataSource {
    
    //MARK: properties
    @IBOutlet weak var collectionIconsView: UICollectionView!
    @IBOutlet weak var walletName: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    
    
    var icons:[String] = [
        "heart","Envelope","money","hospital","basket","book","meal"
    ]//string cac images trong asset
    var preSelectedButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = UIColor(red: 127/255, green: 61/255, blue: 255/255, alpha: 1)
        
        walletName.layer.borderColor =  CGColor(red: 241/250, green: 241/250, blue: 250/250, alpha: 1)
        balanceTextField.attributedPlaceholder = NSAttributedString(string: "$0",attributes: [.foregroundColor: UIColor.white])
        
    }
    //MARK: events
  
// chua hoan thanh
//    func getAllWallet(UID: String) {
//        let db = Firestore.firestore()
//        let userRef = db.collection("Profile").document(UID)
//        let walletRef = userRef.collection("Wallets")
//        walletRef.getDocuments {
//            query, error in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//            if let documents = query?.documents, !documents.isEmpty {
//                for wallet in documents {
//                    let data = wallet.data()
//                    if let name = data["Name"] as? String {
//                        print("name : \(name)")
//                    }
//                    else {
//                        print("Null")
//                    }
//                }
//            } else {
//                print("document not found")
//            }
//
//        }
//    }
    
    //tao vi moi
    func createNewWallet(_ UID: String, _ walletDictionary:[String:Any])->Void {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletRef = userRef.collection("Wallets")
        if walletDictionary.count != 0 {
            walletRef.addDocument(data: walletDictionary) { error in
                if let error = error {
                  print("Error adding wallet: \(error)")
                  return
                }
                print("Wallet created successfully!")
              }
        }
    }
    //cap nhat vi
    func updateAWallet(_ UID: String, _ walletID:String, _ walletDictionary:[String:Any])->Void {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletDoc = userRef.collection("Wallets").document(walletID)
        if walletDictionary.count != 0 {
            walletDoc.updateData(walletDictionary) { error in
                if let error = error {
                  print("Error adding wallet: \(error)")
                  return
                }
                print("Wallet updated successfully!")
              }
        }
    }
    //xoa vi
    func deleteAWallet(_ UID: String, _ walletID:String) {
        let db = Firestore.firestore()
        let userRef = db.collection("Profile").document(UID)
        let walletDoc = userRef.collection("Wallets").document(walletID)
        walletDoc.getDocument { document, error in
            if let error = error {
                print("Error deleting wallet \(error)")
                return
            }
            if let document = document, document.exists {
                walletDoc.delete()
                print("Wallet deleted successfully")
            }
        }
    }
    
    @IBAction func newWalletTapped(_ sender: UIButton) {
        if let balance = balanceTextField.text, let name = walletName.text, !name.isEmpty{
            //          let icon:String = icons[preSelectedButton?.tag ?? 0]
            if let balanceDouble = Double(balance.isEmpty ? "0" : balance) {
                let UID = "siOIdhoJsgZCVlsJsZ4cHjr8cSn2"
                let walletDic = [
                    "Name": name,
                    "Balance": balanceDouble
                ] as [String : Any]
                createNewWallet(UID, _: walletDic)
            }
        } else {
            print("error, name is empty")
        }
//        deleteAWallet("siOIdhoJsgZCVlsJsZ4cHjr8cSn2", "ydSWhPZGYCFOBtDkCmRi")
    }
    
    
    //MARK: implementing classes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuse = "IconAddWalletCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? AddIconWalletCell {
            cell.iconButton.addTarget(self, action: #selector(selectIconTapped(_ :)), for: .touchUpInside)
            cell.iconButton.tag = indexPath.row
            if let image = UIImage(named: icons[indexPath.row]) {
                
                cell.iconButton.setBackgroundImage(image, for: .normal)
                cell.iconButton.setTitle("", for: .normal)
                cell.iconButton.layoutIfNeeded()
                cell.iconButton.subviews.first?.contentMode = .scaleAspectFit
                cell.iconButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1)
                cell.iconButton.layer.cornerRadius = 8
            }
            return cell
        }
        fatalError("khong the return button")
    }
    
    @objc func selectIconTapped(_ sender:UIButton) {
        sender.layer.borderColor = CGColor(red: 127/255, green: 61/255, blue: 255/255, alpha: 1)
        sender.backgroundColor = UIColor(red: 238/255, green: 229/255, blue: 255/255, alpha: 1)
        sender.layer.borderWidth = 1
        if let prvButton = preSelectedButton {
            prvButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 250/255, alpha: 1)
            prvButton.layer.borderWidth = 0
        }
        preSelectedButton = sender
    }
    
}
