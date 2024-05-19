//
//  AddWalletViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 19/02/1403 AP.
//

import UIKit
import FirebaseFirestore

class AddWalletViewController: UIViewController,UITextViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //MARK: properties
    @IBOutlet weak var collectionIconsView: UICollectionView!
    @IBOutlet weak var walletName: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    override var isEditing: Bool  {
        didSet {
            self.navigationItem.rightBarButtonItem?.isHidden = !isEditing
        }
    }

    
    var icons:[String] = [
        "heart","Envelope","money","hospital","basket","book","meal"
    ]//string cac images trong asset
    var preSelectedButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        print("isEditing: \(isEditing)")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = UIColor(red: 127/255, green: 61/255, blue: 255/255, alpha: 1)
        
        balanceTextField.delegate = self
        walletName.layer.borderColor =  CGColor(red: 241/250, green: 241/250, blue: 250/250, alpha: 1)
        balanceTextField.attributedPlaceholder = NSAttributedString(string: "$0",attributes: [.foregroundColor: UIColor.white])
      
    }
     
    //MARK: events
    
    
    
    @IBAction func newWalletTapped(_ sender: UIButton) {
        if let balance = balanceTextField.text,
            let name = walletName.text, !name.isEmpty{
            let icon = icons[preSelectedButton?.tag ?? 0]
            if let balanceDouble = Double(balance.isEmpty ? "0" : balance) {
                let UID = UserDefaults.standard.string(forKey: "UID") ?? ""
                
                let walletDic = [
                    "Name": name,
                    "Balance": balanceDouble,
                    "Image": icon
                ] as [String : Any]
                Wallet.createNewWallet(UID, _: walletDic)
                navigationController?.popViewController(animated: true)
            }
        } else {
            print("error, name is empty")
        }
        //        deleteAWallet("siOIdhoJsgZCVlsJsZ4cHjr8cSn2", "ydSWhPZGYCFOBtDkCmRi")
    }
    
    
    //MARK: implementing classes
    //chan user nhap chu
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) {
                // Nếu có ký tự không phải số, không cho phép thay đổi
                return false
            }

            // Nếu chỉ có số, cho phép thay đổi
            return true
    }
    
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


