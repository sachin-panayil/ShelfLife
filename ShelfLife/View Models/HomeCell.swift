//
//  HomeCell.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDayLeft: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ivItem.borderAndCorner(cornerRadious: 30, borderWidth: 2, borderColor: UIColor(named: "app_green")!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
