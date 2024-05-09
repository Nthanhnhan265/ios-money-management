//
//  AddWalletViewController.swift
//  ios-money-management
//
//  Created by nguyenthanhnhan on 19/02/1403 AP.
//

import UIKit

class AddWalletViewController: UIViewController, UICollectionViewDataSource {
    
    //MARK: properties
    @IBOutlet weak var collectionIconsView: UICollectionView!
    @IBOutlet weak var walletName: UITextField!
    
    var icons:[String] = [
        "delete","Envelope"
    ]//string cac images trong asset
    var preSelectedButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = UIColor(red: 127/255, green: 61/255, blue: 255/255, alpha: 1)
        
        walletName.layer.borderColor =  CGColor(red: 241/250, green: 241/250, blue: 250/250, alpha: 1)
        
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
