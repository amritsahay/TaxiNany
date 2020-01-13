//
//  WeekViewCell.swift
//  TaxiNanny
//
//  Created by ip-d on 11/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class WeekViewCell: UITableViewCell {

    @IBOutlet weak var cardview: CardView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
