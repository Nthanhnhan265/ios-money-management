//
//  TransactionTableViewCell.swift
//  ios-money-management
//
//  Created by AnNguyen on 27/04/2024.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transaction_des: UILabel!
    @IBOutlet weak var transaction_time: UILabel!
    @IBOutlet weak var transaction_balance: UILabel!
    @IBOutlet weak var transaction_title: UILabel!
    @IBOutlet weak var transaction_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Vào TransactionTableViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
