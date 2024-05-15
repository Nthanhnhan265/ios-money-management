//
//  IncomeCell.swift
//  ios-money-management
//
//  Created by AnNguyen on 15/05/2024.
//

import UIKit

class IncomeCell: UITableViewCell {

    @IBOutlet weak var trans_income_time: UILabel!
    @IBOutlet weak var trans_income_des: UILabel!
    @IBOutlet weak var trans_income_balance: UILabel!
    @IBOutlet weak var trans_income_name: UILabel!
    @IBOutlet weak var trans_income_image: UIImageView!
    
    static let identifier = "IncomeCell"
    static func nib() -> UINib{
        return UINib(nibName: "IncomeCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
